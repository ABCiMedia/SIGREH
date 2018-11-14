const Sequelize = require('sequelize')

const credentials = require('./credentials')

const sequelize = new Sequelize(credentials.database, credentials.username, credentials.password, {
    host: credentials.host,
    dialect: credentials.dialect,
    operatorsAliases: false,
    logging: false,
})

const PreRegister = sequelize.define('pre_register', {
    name: Sequelize.STRING,
    address: Sequelize.STRING,
    phone: Sequelize.STRING,
    email: Sequelize.STRING
})

sequelize.sync()

module.exports = {
    PreRegister
}
