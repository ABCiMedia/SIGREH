const Sequelize = require('sequelize');

const cred = require('./credentials');
const sequelize = new Sequelize(cred.database, cred.username, cred.password, {
    host: cred.host,
    dialect: cred.dialect,
    operatorsAliases: false,
    logging: false,
});

const User = sequelize.define('user', {
    username: {type: Sequelize.STRING, unique: true},
    password: {type: Sequelize.STRING},
    group: {type: Sequelize.ENUM(['admin', 'regular'])},
});

sequelize.sync();

exports.User = User;
