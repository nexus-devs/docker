/**
 * NOTE: All paths are relative to the nexus-stats repo config folder
 */
const fs = require('fs')
const certPrivate = fs.readFileSync(`${__dirname}/certs/auth.private.pem`, 'utf-8')
const certPublic = fs.readFileSync(`${__dirname}/certs/auth.public.pem`, 'utf-8')
const mongo = require('../hooks/mongo')
const db = require('../hooks/db')

module.exports = {
  blitz: {
    logLevel: 'silly',
    environment: 'development'
  },
  api: {
    redisUrl: 'redis://redis',
    certPublic
  },
  core: {
    endpointPath: __dirname + '/../api',
    mongoUrl: 'mongodb://admin:123456@rs0,rs1,rs2/warframe-nexus-core?authSource=admin&replicaSet=nexus',
    redisUrl: 'redis://redis',
    hooks: [mongo.verifyItemIndices, db.verifyItemList]
  },
  auth: {
    api: {
      redisUrl: 'redis://redis',
      certPublic,
    },
    core: {
      mongoUrl: 'mongodb://admin:123456@rs0,rs1,rs2/nexus-auth?authSource=admin&replicaSet=nexus',
      redisUrl: 'redis://redis',
    },
    certPrivate,
  },
  view: {
    api: {
      redisUrl: 'redis://redis',
      certPublic
    },
    core: {
      mongoUrl: 'mongodb://admin:123456@rs0,rs1,rs2/nexus-view?authSource=admin&replicaSet=nexus',
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
