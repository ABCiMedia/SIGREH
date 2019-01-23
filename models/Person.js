const Sequelize = require('sequelize')

const {User} = require('./User')
    , {Formation} = require('./Formation')
    , { Agente } = require('./Agente')

const credentials = require('./credentials')

const sequelize = new Sequelize(credentials.database, credentials.username, credentials.password, {
    host: credentials.host,
    dialect: credentials.dialect,
    operatorsAliases: false,
    logging: false,
})

const Person = sequelize.define('person', {
    name: {type: Sequelize.STRING},
    birthdate: {type: Sequelize.DATEONLY},
    address: {type: Sequelize.STRING},
    phone: {type: Sequelize.STRING},
    email: {type: Sequelize.STRING},
    bi: {type: Sequelize.STRING},
    nif: {type: Sequelize.INTEGER},
    gender: {type: Sequelize.STRING},
    state: {type: Sequelize.ENUM(['registered', 'waiting_formation', 'formation', 'internship', 'hired', 'reserved', 'gave_up'])},
    score: Sequelize.REAL,
    scoreText: Sequelize.STRING,
    group: Sequelize.ENUM(['gerente', 'subgerente', 'outro'])
})

Person.belongsTo(User)
Person.belongsToMany(Formation, {through: 'PersonFormation'})
Formation.belongsToMany(Person, {through: 'PersonFormation'})
Person.belongsTo(Agente)

sequelize.sync()

module.exports = {
    Person,
    connection: sequelize
}
