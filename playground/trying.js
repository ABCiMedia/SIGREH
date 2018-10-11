const Sequelize = require('sequelize');

const {Person} = require('../models/Person');

const Op = Sequelize.Op;

Person.findAndCount({
    where: {'score': {
        [Op.ne]: null
    }}
}).then((r) => {
    console.log(r.count);
});
