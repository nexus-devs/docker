const prod = process.env.NODE_ENV === 'production'
const target = process.env.NEXUS_TARGET_NODE
const group = target.split('-')[0]
const node = target.split('-')[1]
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
const xor = (obj, key) => obj[key] || (obj.core ? obj.core[key] : null)

/**
 * There's a slim chance that redis isn't up before launch (~10% occurance)
 */
async function waitRedis() {
  let resolved = false

  while (!resolved) {
    let resolve, reject
    let stop = new Promise((res, rej) => {
      resolve = res
      reject = rej
    })
    let client = redis.createClient(xor(config, 'redisUrl'))
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
async function verifyCredentials() {
  const userKey = xor(config, 'userKey')
  const userSecret = xor(config, 'userSecret')
  let mongo, db

  // Attempt connection until ready. Replica set is certain to be initiated
  // when connection succeeds, since we'd get unauthorized errors otherwise.
  while (true) {
    try {
      mongo = await mongodb.connect(xor(config, 'mongoUrl'))
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
      scope: `write_root ${target.includes('auth') ? ' write_auth' : ''}`,
      refresh_token: null
    }
  }, {
    upsert: true
  })
  console.log('* User verification successful!')
  mongo.close()
}

waitRedis()
if (node === 'core') {
  verifyCredentials()
}
