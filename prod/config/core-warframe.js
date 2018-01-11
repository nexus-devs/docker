const fs = require('fs')
const wf = require('../hooks/warframe.js')
const userKey = fs.readFileSync('/run/secrets/nexus-core-warframe-key', 'utf-8').replace(/(\n|\r)+$/, '')
const userSecret = fs.readFileSync('/run/secrets/nexus-core-warframe-secret', 'utf-8').replace(/(\n|\r)+$/, '')
const dbSecret = fs.readFileSync('/run/secrets/mongo-admin-pwd', 'utf-8').replace(/(\n|\r)+$/, '')
const mongoUrl = `mongodb://admin:${dbSecret}@mongo/admin?replicaSet=nexus`
const redisUrl = 'redis://redis'

module.exports = {
  blitz: {
    logLevel: 'monitor',
    environment: 'production',
    skipAuthCheck: true
  },
  api: {
    disable: true
  },
  core: {
    endpointPath: __dirname + '/../api/core-warframe',
    apiUrl: 'http://api_warframe:3000',
    authUrl: 'http://api_auth:3000',
    userKey,
    userSecret,
    mongoUrl,
    mongoDb: 'nexus-core-warframe',
    redisUrl,
    hooks: [ wf.verifyIndices, wf.verifyItemList ],
    id: 'warframe_core'
  },
  auth: {
    disable: true
  },
  view: {
    disable: true
  }
}
