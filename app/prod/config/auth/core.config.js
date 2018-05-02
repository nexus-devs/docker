const fs = require('fs')
const certPrivate = fs.readFileSync(`/run/secrets/nexus-private-key`, 'utf-8')
const userKey = fs.readFileSync('/run/secrets/nexus-core-auth-key', 'utf-8').replace(/(\n|\r)+$/, '')
const userSecret = fs.readFileSync('/run/secrets/nexus-core-auth-secret', 'utf-8').replace(/(\n|\r)+$/, '')
const dbSecret = fs.readFileSync('/run/secrets/mongo-admin-pwd', 'utf-8').replace(/(\n|\r)+$/, '')
const mongoUrl = `mongodb://admin:${dbSecret}@mongo/admin?replicaSet=nexus`
const redisUrl = 'redis://redis'

module.exports = {
  cubic: {
    logLevel: 'monitor',
    environment: 'production',
    skipAuthCheck: true
  },
  api: {
    disable: true
  },
  core: {
    disable: true
  },
  auth: {
    api: {
      disable: true
    },
    core: {
      apiUrl: 'http://api_auth:3000',
      authUrl: 'http://api_auth:3000',
      userKey,
      userSecret,
      mongoUrl,
      mongoDb: 'nexus-core-auth',
      redisUrl,
      id: 'auth_core'
    },
    certPrivate
  },
  view: {
    disable: true
  }
}
