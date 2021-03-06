const Sequelize = require('sequelize')

const { Person } = require('./Person')
const { User } = require('./User')
const credentials = require('./credentials')

const sequelize = new Sequelize(credentials.database, credentials.username, credentials.password, {
    host: credentials.host,
    dialect: credentials.dialect,
    operatorsAliases: false,
    logging: false,
})

const Increase = sequelize.define('increase', {
    quantity: Sequelize.FLOAT,
    reason: Sequelize.STRING
})

Increase.belongsTo(Person)
Increase.belongsTo(User)

sequelize.sync()

module.exports = {
    Increase,
    connection: sequelize
}
