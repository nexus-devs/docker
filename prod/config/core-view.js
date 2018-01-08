const fs = require('fs')
const userKey = fs.readFileSync('/run/secrets/nexus-core-view-key', 'utf-8').replace(/(\n|\r)+$/, '')
const userSecret = fs.readFileSync('/run/secrets/nexus-core-view-secret', 'utf-8').replace(/(\n|\r)+$/, '')
const dbSecret = fs.readFileSync('/run/secrets/mongo-admin-pwd', 'utf-8').replace(/(\n|\r)+$/, '')
const mongoUrl = `mongodb://admin:${dbSecret}@mongo/admin?replicaSet=nexus`
const redisUrl = 'redis://redis'

module.exports = {
  blitz: {
    logLevel: 'monitor',
    environment: 'production'
  },
  api: {
    disable: true
  },
  core: {
    disable: true
  },
  auth: {
    disable: true
  },
  view: {
    api: {
      disable: true
    },
    core: {
      endpointPath: __dirname + '/../view/endpoints',
      sourcePath: __dirname + '/../view',
      publicPath: __dirname + '/../assets',
      apiUrl: 'http://api_view',
      authUrl: 'http://api_auth',
      userKey,
      userSecret,
      mongoUrl,
      mongoDb: 'nexus-core-view',
      redisUrl,
      id: 'view_core'
    },
    client: {
      apiUrl: 'https://api.nexus-stats.com',
      authUrl: 'https://auth.nexus-stats.com'
    }
  }
}
