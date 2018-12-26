/**
 * Adapted from /app/prod/prelaunch.js
 */
const config = require('/app/nexus-stats/config/cubic/auth.js')
const mongodb = require('mongodb').MongoClient
const redis = require('redis')
const sleep = (ms) => new Promise(resolve => setTimeout(() => resolve(), ms))

/**
 * There's a slim chance that redis isn't up before launch (~10% occurance)
 */
async function waitRedis() {
  let resolved = false
  console.log('\n* Waiting for Redis...')

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
      console.log('* Redis is up!')
      resolved = true
    } catch (err) {
      await sleep(100)
    }
  }
}

/**
 * If this is a core node, ensure the credentials are stored on mongo.
 * This also ensures the replica set is ready before we launch the app.
 */
async function waitMongo() {
  let mongo, db
  console.log('\n* Waiting for Mongodb...')

  // Attempt connection until ready. Replica set is certain to be initiated
  // when connection succeeds, since we'd get unauthorized errors otherwise.
  while (true) {
    try {
      mongo = await mongodb.connect(config.api.mongoUrl, { useNewUrlParser: true })
      db = mongo.db('nexus-auth')
      console.log('* Mongodb is up!')
      mongo.close()
      break
    } catch (err) {
      await sleep(100)
    }
  }
}

async function wait() {
  await waitRedis()
  await waitMongo()
}
wait()
