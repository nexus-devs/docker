/**
 * NOTE: All paths are relative to the nexus-stats repo config folder
 */
const fs = require('fs')
const certPrivate = fs.readFileSync(`/run/secrets/nexus-private-key`, 'utf-8')
const certPublic = fs.readFileSync(`/run/secrets/nexus-public-key`, 'utf-8')
const wf = require('../hooks/warframe.js')
const dbSecret = fs.readFileSync(`/run/secrets/mongo-admin-pwd`, 'utf-8').replace(/(\n|\r)+$/, '')
const mongoUrl = `mongodb://admin:${dbSecret}@mongo/admin?replicaSet=nexus`
const redisUrl = 'redis://redis'

module.exports = {
  blitz: {
    logLevel: 'silly',
    environment: 'development'
  },
  api: {
    redisUrl,
    certPublic
  },
  core: {
    endpointPath: __dirname + '/../api/core-warframe',
    mongoUrl,
    mongoDb: 'nexus-core-warframe',
    redisUrl,
    hooks: [ wf.verifyIndices, wf.verifyItemList ],
    id: 'warframe_core'
  },
  auth: {
    api: {
      redisUrl,
      certPublic,
    },
    core: {
      mongoUrl,
      mongoDb: 'nexus-auth',
      redisUrl,
    },
    certPrivate,
  },
  view: {
    api: {
      redisUrl,
      certPublic
    },
    core: {
      mongoUrl,
      mongoDb: 'nexus-view',
      redisUrl,
      endpointPath: __dirname + '/../view/endpoints',
      sourcePath: __dirname + '/../view',
      publicPath: __dirname + '/../assets',
    },
    client: {
      apiUrl: 'https://api.nexus-stats.com',
      authUrl: 'https://auth.nexus-stats.com'
    }
  }
}
