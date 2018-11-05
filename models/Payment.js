const Sequelize = require('sequelize')

const cred = require('./credentials')
const {Person} = require('./Person')

const connection = new Sequelize(cred.database, cred.username, cred.password, {
    host: cred.host,
    dialect: cred.dialect,
    operatorsAliases: false,
    logging: false
})

const Payment = connection.define('payment', {
    toPay: Sequelize.REAL,
    paid: Sequelize.REAL,
    discount: Sequelize.REAL
})

Payment.belongsTo(Person)

Payment.sync()

module.exports = {
    Payment
}