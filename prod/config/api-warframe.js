const fs = require('fs')
const certPublic = fs.readFileSync(`/run/secrets/nexus-public-key`, 'utf-8')
const redisUrl = 'redis://redis'

module.exports = {
  blitz: {
    logLevel: 'monitor',
    environment: 'production',
    skipAuthCheck: true
  },
  api: {
    port: 3000,
    redisUrl,
    certPublic,
    cacheExp: 60
  },
  core: {
    disable: true
  },
  auth: {
    disable: true
  },
  view: {
    disable: true
  }
}
