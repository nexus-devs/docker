/**
 * NOTE: All paths are relative to the nexus-stats repo config folder
 */
const mongo = require('../hooks/mongo')
const db = require('../hooks/db')

module.exports = {
  blitz: {
    logLevel: 'silly',
    environment: 'development'
  },
  api: {
    redisUrl: 'redis://redis',
  },
  core: {
    endpointPath: __dirname + '/../api',
    mongoUrl: 'mongodb://admin:123456@rs0,rs1,rs2/warframe-nexus-core?authSource=admin',
    redisUrl: 'redis://redis'
    hooks: [mongo.verifyItemIndices, db.verifyItemList]
  },
  auth: {
    api: {
      redisUrl: 'redis://redis',
    },
    core: {
      mongoUrl: 'mongodb://admin:123456@rs0,rs1,rs2/warframe-nexus-auth?authSource=admin',
      redisUrl: 'redis://redis',
    }
  },
  view: {
    api: {
      redisUrl: 'redis://redis',
    },
    core: {
      mongoUrl: 'mongodb://admin:123456@rs0,rs1,rs2/warframe-nexus-view?authSource=admin',
      redisUrl: 'redis://redis',
      endpointPath: __dirname + '/../view/endpoints',
      sourcePath: __dirname + '/../view',
      publicPath: __dirname + '/../assets'
    },
    client: {
      apiUrl: 'https://api.nexus-stats.com',
      authUrl: 'https://auth.nexus-stats.com'
    }
  }
}
