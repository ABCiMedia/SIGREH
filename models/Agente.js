const Sequelize = require('sequelize')

const credentials = require('./credentials')

const sequelize = new Sequelize(credentials.database, credentials.username, credentials.password, {
    host: credentials.host,
    dialect: credentials.dialect,
    operatorsAliases: false,
    logging: false,
})

const Agente = sequelize.define('agente', {
    nome: Sequelize.STRING
})

sequelize.sync()

module.exports = {
    Agente,
    connection: sequelize
}
