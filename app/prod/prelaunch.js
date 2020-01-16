const node = process.env.NEXUS_TARGET_NODE
const fs = require('fs')
const configs = {
  auth: require('./config/cubic/auth.js'),
  ui: require('./config/cubic/ui.js'),
  'api-warframe': require('./config/cubic/api.js')
}
const config = configs[node]
const bcrypt = require('bcryptjs')
const mongodb = require('mongodb').MongoClient
const redis = require('redis')
const sleep = (ms) => new Promise(resolve => setTimeout(() => resolve(), ms))

async function pre() {
  let mongo, db, done

  /**
   * Attempt connection until ready. Replica set is certain to be initiated
   * when connection succeeds, since we'd get unauthorized errors otherwise.
   */
  while (!done) {
    try {
      const mongoUrl = node.slice(0, 3) === 'api' ? config.mongoUrl : config.api.mongoUrl
      mongo = await mongodb.connect(mongoUrl, { useNewUrlParser: true })
      db = mongo.db('nexus-auth')
      db.command({ "replSetGetStatus": 1 }, err => {
        if (!err) {
          done = true
        }
      })
      console.log('\n* Mongodb is up!')
      break
    } catch (err) {
      console.log(err)
      console.log('Retrying in 500ms...')
      await sleep(500)
    }
  }

  /**
   * Ensure credentials are stored on mongo.
   * This also ensures the replica set is ready before we launch the app.
   */
  async function verifyCredentials(target, userKey, userSecret, scope) {
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
    const redisUrl = node.slice(0, 3) === 'api' ? config.redisUrl : config.api.redisUrl
    let client = redis.createClient(redisUrl)
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
      console.log(err)
      console.log('Retrying in 500ms...')
      await sleep(500)
    }
  }

  /**
   * Check user credentials for given node
   */
  if (node === 'ui') {
    await verifyCredentials('cubic-ui', config.server.user_key, config.server.user_secret, 'write_root')
  }
  if (node.slice(0, 3) === 'api') {
    const key = fs.readFileSync('/run/secrets/nexus-warframe-bot-key', 'utf-8').trim()
    const secret = fs.readFileSync('/run/secrets/nexus-warframe-bot-secret', 'utf-8').trim()
    await verifyCredentials('nexus-warframe-bot', key, secret, 'write_orders_warframe ignore_rate_limit')
  }
}

pre().then(() => process.exit())
