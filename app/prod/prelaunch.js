const targetNode = process.env.NEXUS_TARGET_NODE
const fs = require('fs')
const group = targetNode.split('-')[0]
const node = targetNode.split('-')[1]
const configs = {
  auth: require('./config/cubic/auth.js'),
  ui: require('./config/cubic/ui.js'),
  main: require('./config/cubic/main.js'),
  warframe: require('./config/cubic/warframe.js')
}
const config = configs[group][node]
const bcrypt = require('bcryptjs')
const mongodb = require('mongodb').MongoClient
const redis = require('redis')
const sleep = (ms) => new Promise(resolve => setTimeout(() => resolve(), ms))
const xor = (obj, key, node) => obj[key] || (obj[node] ? obj[node][key] : null)

/**
 * There's a slim chance that redis isn't up before launch (~10% occurance)
 */
async function waitRedis () {
  let resolved = false

  while (!resolved) {
    let resolve, reject
    let stop = new Promise((res, rej) => {
      resolve = res
      reject = rej
    })
    let client = redis.createClient(xor(config, 'redisUrl', 'core'))
    client.on('ready', () => {
      client.quit()
      resolve()
    })
    client.on('error', () => {
      reject()
    })
    try {
      await stop
      resolved = true
      console.log('\n* Redis is up!')
    } catch (err) {
      await sleep(500)
    }
  }
}

/**
 * If this is a core node, ensure the credentials are stored on mongo.
 * This also ensures the replica set is ready before we launch the app.
 */
async function verifyCredentials (target, key, secret, scope) {
  const userKey = key || xor(config, 'userKey', node)
  const userSecret = secret || xor(config, 'userSecret', node)
  let mongo, db

  // Attempt connection until ready. Replica set is certain to be initiated
  // when connection succeeds, since we'd get unauthorized errors otherwise.
  while (true) {
    try {
      mongo = await mongodb.connect(xor(config, 'mongoUrl', 'core'))
      db = mongo.db('nexus-auth')
      console.log('\n* Mongodb is up!')
      break
    } catch (err) {
      await sleep(500)
    }
  }
  await db.collection('users').updateOne({
    user_key: userKey
  }, {
    $set: {
      user_id: target,
      user_key: userKey,
      user_secret: await bcrypt.hash(userSecret, 8),
      last_ip: [],
      scope,
      refresh_token: null
    }
  }, {
    upsert: true
  })
  console.log('* User verification successful!')
  mongo.close()
}

waitRedis()
const scope = `write_root ${node === 'core' && group === 'auth' ? ' write_auth' : ''}`
verifyCredentials(targetNode, null, null, scope)

// User accounts for external system clients like the OCR bot
if (group === 'warframe' && node === 'core') {
  const key = fs.readFileSync('/run/secrets/nexus-warframe-bot-key', 'utf-8').trim()
  const secret = fs.readFileSync('/run/secrets/nexus-warframe-bot-secret', 'utf-8').trim()
  verifyCredentials('nexus-warframe-bot', key, secret, 'write_orders_warframe')
}
