const Sequelize = require('sequelize');

const cred = require('./credentials')
    , { Person} = require('./Person');

const sequelize = new Sequelize(cred.database, cred.username, cred.password, {
    host: cred.host,
    dialect: cred.dialect,
    operatorsAliases: false,
    logging: false
});

const Formation = sequelize.define('formation', {
    name: Sequelize.STRING,
    description: Sequelize.TEXT,
    teoric_part: Sequelize.STRING,
    pratic_part: Sequelize.STRING,
    subscription_cost: Sequelize.REAL,
    certificate_cost: Sequelize.REAL
});

Person.belongsToMany(Formation, {through: 'PersonFormation'});
Formation.belongsToMany(Person, {through: 'PersonFormation'});

sequelize.sync();

module.exports = {
    Formation
}