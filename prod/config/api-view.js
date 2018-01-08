const fs = require('fs')
const certPublic = fs.readFileSync(`/run/secrets/nexus-public-key`, 'utf-8')
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
      port: 80,
      redisUrl,
      certPublic,
      cacheExp: 60
    },
    core: {
      disable: true
    }
  }
}
