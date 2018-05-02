const fs = require('fs')
const certPublic = fs.readFileSync(`/run/secrets/nexus-public-key`, 'utf-8')
const certPrivate = fs.readFileSync(`/run/secrets/nexus-private-key`, 'utf-8')
const userKey = fs.readFileSync('/run/secrets/nexus-core-auth-key', 'utf-8').replace(/(\n|\r)+$/, '')
const userSecret = fs.readFileSync('/run/secrets/nexus-core-auth-secret', 'utf-8').replace(/(\n|\r)+$/, '')
const dbSecret = fs.readFileSync('/run/secrets/mongo-admin-pwd', 'utf-8').replace(/(\n|\r)+$/, '')
const mongoUrl = `mongodb://admin:${dbSecret}@mongo/admin?replicaSet=nexus`
const redisUrl = 'redis://redis'

module.exports = {
  cubic: {
    logLevel: 'verbose',
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
      port: 3000,
      redisUrl,
      certPublic,
      cacheExp: 60
    },
    core: {
      disable: true,
      userKey,
      userSecret,
      mongoUrl,
      mongoDb: 'nexus-core-auth'
    },
    certPrivate
  },
  view: {
    disable: true
  }
}
