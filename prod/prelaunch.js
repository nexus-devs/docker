/**
 * This script takes care of a few requirements before we actually launch our
 * node.
 */
const config = require('./config/blitz.config.js')
const bcrypt = require('bcryptjs')
const mongodb = require('mongodb').MongoClient

/**
 * If this is a core node, ensure the credentials are stored on mongo
 * This also ensures the replica set is ready before we launch the app
 */
async function verifyCredentials() {
  const node = Object.keys(config).find(c => c.userKey || c.core.userKey)

  if (node) {
    const userKey = node.userKey || node.core.userKey
    const userSecret = node.userSecret || node.core.userSecret
    const mongo = await mongodb.connect(node.mongoUrl || node.core.mongoUrl)
    const db = mongo.db(node.mongoDb || node.core.mongoDb)

    await db.collection('users').updateOne({
      user_key: userKey
    }, {
      user_id: node.id || node.core.id,
      user_key: userKey,
      user_secret: await bcrypt.hash(userSecret, 8),
      last_ip: [],
      scope: 'write_root',
      refresh_token: null
    }, {
      upsert: true
    })
  }
}

verifyCredentials()