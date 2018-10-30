const Sequelize = require('sequelize')

const { Person } = require('./Person')
const credentials = require('./credentials')

const sequelize = new Sequelize(credentials.database, credentials.username, credentials.password, {
    host: credentials.host,
    dialect: credentials.dialect,
    operatorsAliases: false,
    logging: false,
});

const Discount = sequelize.define('discount', {
    quantity: Sequelize.FLOAT,
    reason: Sequelize.STRING
})

Discount.belongsTo(Person);

sequelize.sync();

module.exports = {
    Discount,
    connection: sequelize
};
