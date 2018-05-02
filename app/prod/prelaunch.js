const config = require('./config/cubic.config.js')
const bcrypt = require('bcryptjs')
const mongodb = require('mongodb').MongoClient
const redis = require('redis')
const sleep = (ms) => new Promise(resolve => setTimeout(() => resolve(), ms))
const xor = (obj, key) => obj[key] || (obj.core ? obj.core[key] : null)

/**
 * There's a slim chance that redis isn't up before launch (~10% occurance)
 */
async function waitRedis() {
  const node = Object.keys(config).find(c => xor(config[c], 'redisUrl'))
  const conf = config[node]

  if (conf) {
    while (true) {
      let stop = new Promise(() => {})
      redis.createClient(xor(conf, 'redisUrl'))
      redis.on('ready', () => {
        console.log('Redis is up!')
        redis.quit()
        stop.resolve()
        break
      })
      redis.on('error', () => {
        stop.resolve()
      })
      await stop
      await sleep(5000)
    }
  }
}

/**
 * If this is a core node, ensure the credentials are stored on mongo
 * This also ensures the replica set is ready before we launch the app
 */
async function verifyCredentials() {
  const node = Object.keys(config).find(c => xor(config[c], 'userKey'))
  const conf = config[node]

  if (conf) {
    const userKey = xor(conf, 'userKey')
    const userSecret = xor(conf, 'userSecret')
    let mongo, db

    // Attempt connection until ready. Replica set is certain to be initiated
    // when connection succeeds, since we'd get unauthorized errors otherwise.
    while (true) {
      try {
        mongo = await mongodb.connect(xor(conf, 'mongoUrl'))
        db = mongo.db('nexus-core-auth')
        break
      } catch (err) {
        await sleep(5000)
      }
    }

    await db.collection('users').updateOne({
      user_key: userKey
    }, {
      $set: {
        user_id: xor(conf, 'id'),
        user_key: userKey,
        user_secret: await bcrypt.hash(userSecret, 8),
        last_ip: [],
        scope: 'write_root',
        refresh_token: null
      }
    }, {
      upsert: true
    })
    mongo.close()
    console.log('User verification successful!')
  }
}

verifyCredentials()