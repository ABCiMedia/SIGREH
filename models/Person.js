const Sequelize = require('sequelize')

const {User} = require('./User')
    , {Formation} = require('./Formation');

const credentials = require('./credentials');

const sequelize = new Sequelize(credentials.database, credentials.username, credentials.password, {
    host: credentials.host,
    dialect: credentials.dialect,
    operatorsAliases: false,
    logging: false,
});

const Person = sequelize.define('person', {
    name: {type: Sequelize.STRING},
    birthdate: {type: Sequelize.DATEONLY},
    address: {type: Sequelize.STRING},
    phone: {type: Sequelize.STRING},
    email: {type: Sequelize.STRING},
    bi: {type: Sequelize.INTEGER},
    nif: {type: Sequelize.INTEGER},
    gender: {type: Sequelize.STRING},
    state: {type: Sequelize.ENUM(['registered', 'formation', 'internship', 'hired', 'reserved'])},
    score: Sequelize.REAL,
    scoreText: Sequelize.STRING
});

Person.belongsTo(User);
Person.belongsToMany(Formation, {through: 'PersonFormation'});
Formation.belongsToMany(Person, {through: 'PersonFormation'});

sequelize.sync();

module.exports = {
    Person,
    connection: sequelize
};