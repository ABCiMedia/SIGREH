const Sequelize = require('sequelize')

const sequelize = new Sequelize('zzdxmqvw', 'zzdxmqvw', 'gciJ4pwDJh0LxYv4J-f6meFt35SzoInu', {
    host: 'stampy.db.elephantsql.com',
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