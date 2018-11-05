const Sequelize = require('sequelize')

const credentials = require('./credentials')
const {Person, } = require('./Person')
const {User} = require('./User')

const sequelize = new Sequelize(credentials.database, credentials.username, credentials.password, {
    host: credentials.host,
    dialect: credentials.dialect,
    operatorsAliases: false,
    logging: false,
})

const Evaluation = sequelize.define('evaluation', {
    shop: {type: Sequelize.STRING},
    shift_from: {type: Sequelize.TIME},
    shift_to: {type: Sequelize.TIME},
    shop_number: {type: Sequelize.INTEGER},
    date_from: {type: Sequelize.DATEONLY},
    date_to: {type: Sequelize.DATEONLY},
    cachier: {type: Sequelize.INTEGER},
    cleaning: {type: Sequelize.INTEGER},
    customer_service: {type: Sequelize.INTEGER},
    replacement: {type: Sequelize.INTEGER},
    team_work: {type: Sequelize.INTEGER},
    cold_meats: {type: Sequelize.INTEGER},
    flexibility: {type: Sequelize.INTEGER},
    autonomy: {type: Sequelize.INTEGER},
    punctuality: {type: Sequelize.INTEGER},
    honesty: {type: Sequelize.INTEGER},
    proactivity: {type: Sequelize.INTEGER},
    responsability: {type: Sequelize.INTEGER},
    interest_level: {type: Sequelize.INTEGER},
    availability: {type: Sequelize.INTEGER},
    personal_hygiene: {type: Sequelize.INTEGER},
    obs: {type: Sequelize.TEXT},
    responsible_hr: {type: Sequelize.STRING},
    advisor: {type: Sequelize.STRING}
})

Person.hasMany(Evaluation)
Evaluation.belongsTo(User)

sequelize.sync()

module.exports = {
    Evaluation,
    connection: sequelize
}
