const Sequelize = require('sequelize')

const sequelize = new Sequelize('innov195_sigreh', 'innov195_rh', 'Sigreh11#@.m', {
    host: 'innovatmedia.com',
    port: 5433,
    dialect: 'postgres',
    operatorsAliases: false
})

const User = sequelize.define('user', {
    username: Sequelize.STRING,
    birthday: Sequelize.DATE
});

sequelize.sync()
.then(() => User.create({
    username: 'janedoe',
    birthday: new Date(1980, 6, 20)
}))
.then(jane => {
    console.log(jane.toJSON());
});

module.exports = {
    User
}