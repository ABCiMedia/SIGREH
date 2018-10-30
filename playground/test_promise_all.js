const { Evaluation } = require('../models/Evaluation')
const { Discount } = require('../models/Discount')

Promise.all([
    Evaluation.findAll({
        where: {
            personId: 6
        }
    }),
    Discount.findAll({
        where: {
            personId: 6
        }
    })
])
.then((r) => {
    console.log('Evaluations', JSON.stringify(r[0], null, 2))
    console.log('Discount', JSON.stringify(r[1], null, 2))
})