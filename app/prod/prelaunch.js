const node = process.env.NEXUS_TARGET_NODE
const fs = require('fs')
const configs = {
  auth: require('./config/cubic/auth.js'),
  ui: require('./config/cubic/ui.js'),
  main: require('./config/cubic/main.js'),
  warframe: require('./config/cubic/warframe.js')
}
const config = configs[node]
const bcrypt = require('bcryptjs')
const mongodb = require('mongodb').MongoClient
const redis = require('redis')
const sleep = (ms) => new Promise(resolve => setTimeout(() => resolve(), ms))

async function pre () {
  /**
   * Ensure credentials are stored on mongo.
   * This also ensures the replica set is ready before we launch the app.
   */
  async function verifyCredentials (target, userKey, userSecret, scope) {
    let mongo, db

    // Attempt connection until ready. Replica set is certain to be initiated
    // when connection succeeds, since we'd get unauthorized errors otherwise.
    while (true) {
      try {
        mongo = await mongodb.connect(xor(config, 'mongoUrl'), { useNewUrlParser: true })
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
      }
    }, {
      upsert: true
    })
    console.log('* User verification successful!')
    mongo.close()
  }

  /**
   * There's a slim chance that redis isn't up yet
   */
  let resolved = false

  while (!resolved) {
    let resolve, reject
    let stop = new Promise((res, rej) => {
      resolve = res
      reject = rej
    })
    let client = redis.createClient(config.api.redisUrl)
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

  /**
   * Check user credentials for given node
   */
  if (node === 'ui') {
    await verifyCredentials('cubic-ui', config.client.user_key, config.client.user_secret, 'write_root')
  }
  if (node === 'warframe') {
    const key = fs.readFileSync('/run/secrets/nexus-warframe-bot-key', 'utf-8').trim()
    const secret = fs.readFileSync('/run/secrets/nexus-warframe-bot-secret', 'utf-8').trim()
    await verifyCredentials('nexus-warframe-bot', key, secret, 'write_orders_warframe ignore_rate_limit')
  }
}

pre().then(() => process.exit())
