const express = require("express")
const hbs = require("hbs")
const { check, validationResult } = require("express-validator/check")
const passport = require("passport")
const LocalStrategy = require("passport-local").Strategy
const session = require("express-session")
const uuid = require("uuid/v4")
const bcrypt = require("bcrypt-nodejs")
const PostgreSQLStore = require('connect-pg-simple')(session)
const Sequelize = require("sequelize")

const { Person } = require("./models/Person")
const { Evaluation } = require("./models/Evaluation")
const { User } = require("./models/User")
const { Formation } = require("./models/Formation")
const { Payment } = require("./models/Payment")
const { Discount } = require('./models/Discount')
const { Increase } = require('./models/Increase')
const { PreRegister } = require('./models/PreRegister')
const utils = require("./utils")
const cred = require("./models/credentials")
const {logger} = require('./logging')

///// CONFIGURING PASSPORT WITH LOCAL STRATEGY
passport.use(
    new LocalStrategy((username, password, done) => {
        User.findOne({ where: { username } })
        .then(user => {
            if (!user) {
                return done(null, false, { param: "Credenciais", msg: "Invalidas" })
            }
            if (!bcrypt.compareSync(password, user.password)) {
                return done(null, false, { param: "Credenciais", msg: "Invalidas" })
            }
            return done(null, user)
        })
        .catch(err => done({ param: "Credenciais", msg: "Invalidas" }))
    })
)

passport.serializeUser((user, done) => {
    done(null, user.id)
})

passport.deserializeUser((id, done) => {
    User.findByPk(id)
    .then(res => {
        user = res || false
        done(null, user)
    })
    .catch(error => done(error, false))
})

const app = express()
const port = process.env.PORT || 3000

app.set("view engine", "hbs")
hbs.registerPartials(__dirname + "/views/partials")

/////// HELPERS
hbs.registerHelper("select", (name, selected, options) => {
    options = JSON.parse(options)
    let result = `<select name='${name}'>`
    result += `<option value='${selected}' selected>${utils.portMap.get(selected)}</option>`

    for (key in options) {
        if (key !== selected) {
            result += `<option value='${key}'>${options[key]}</option>`
        }
    }
    result += "</select>"
    return result
})

hbs.registerHelper("radio", function(name, context) {
    let result = ""
    checked = this.hasOwnProperty(context) ? parseInt(this[context][name]) : null

    for (let i = 1; i <= 5; i++) {
        if (i === checked) {
            result += `
                <div class='input-field inline'>
                    <label for='${i}'>
                        <input type='radio' name='${name}' id='${i}' value=${i} checked>
                        <span></span>
                    </label>
                </div>`
        } else {
            result += `
                <div class='input-field inline'>
                    <label for='${name + i}'>
                        <input type='radio' name='${name}' id='${name + i}' value=${i}>
                        <span></span>
                    </label>
                </div>`
        }
    }
    return new hbs.SafeString(result)
})

const log = (req, res) => {
    username = req.user ? username = req.user.username : 'Anónimo'
    logger.info(`${req.method} ${req.url} ${res.statusCode} [${username}]`)
}

//////// MIDLEWARES

app.use((req, res, next) => {
    logger.info(`${req.method} ${req.url} ${res.statusCode}`)
    next()
});
app.use(express.static(__dirname + "/public"))
app.use(express.urlencoded({ extended: false }))
app.use(express.json())

app.use(
    session({
        secret: "a58496e0-32ee-43ee-a30e-0f8a565ba3b7",
        genid: () => uuid(),
        store: new PostgreSQLStore({
            conObject: {
                user: cred.username,
                password: cred.password,
                host: cred.host,
                port: 5432,
                database: cred.database
            }
        }),
        saveUninitialized: true,
        resave: false
    })
)
app.use(passport.initialize())
app.use(passport.session())

/////// HANDLERS

app.get("/", (req, res) => {
    log(req, res)
    if (!req.user) return res.redirect("/login")

    let options = {
        pageTitle: "Painel de Controlo",
        user: req.user,
        admin: req.user.group === 'admin',
        avaliador: req.user.group === 'avaliador'
    }

    Person.findAndCountAll()
    .then(r => {
        options.peopleInDB = r.count
        return Person.findAndCountAll({
            where: {
                state: "registered"
            }
        })
    })
    .then(r => {
        options.peopleRegistered = r.count
        return Person.findAndCountAll({
            where: {
                state: 'waiting_formation'
            }
        })
    })
    .then(r => {
        options.peopleWaiting = r.count
        return Person.findAndCountAll({
            where: {
                state: "formation"
            }
        })
    })
    .then(r => {
        options.peopleFormating = r.count
        return Person.findAndCountAll({
            where: {
                state: "internship"
            }
        })
    })
    .then(r => {
        options.peopleInInternship = r.count
        return Person.findAndCountAll({
            where: {
                state: "hired"
            }
        })
    })
    .then(r => {
        options.peopleHired = r.count
        return Person.findAndCountAll({
            where: {
                state: "reserved"
            }
        })
    })
    .then(r => {
        options.peopleReserved = r.count
        return Person.findAndCountAll({
            where: {
                state: 'gave_up'
            }
        })
    })
    .then(r => {
        options.peopleGaveUp = r.count
        return Person.findAndCountAll({
            where: {
                score: {
                    [Sequelize.Op.ne]: null
                }
            }
        })
    })
    .then(r => {
        options.peopleEvaluated = r.count
        return res.render("dashboard", options)
    })
    .catch(e => logger.error(e))
})

app.get("/inscrever", (req, res) => {
    log(req, res)
    if (!req.user || req.user.group === 'avaliador') return res.redirect("/login")

    return res.render("register", {
        pageTitle: "Inscrições",
        user: req.user,
        admin: req.user.group === 'admin'
    })
})

app.post("/inscrever", [
    check("name").isString(),
    check("birthdate").isBefore(new Date().toLocaleDateString()),
    check("phone").isMobilePhone(),
    check("bi").isNumeric(),
    check("nif").isNumeric(),
    check("gender").isIn(["male", "female"])
], (req, res) => {
    log(req, res)
    if (!req.user || req.user.group === 'avaliador') return res.redirect("/login")

    const errors = validationResult(req)
    if (!errors.isEmpty()) {
        let options = {
            pageTitle: "Inscrições",
            error: utils.changeError(errors.array()[0]),
            form_data: req.body,
            user: req.user,
            admin: req.user.group === 'admin'
        }
        return res.render("register", options)
    } else {
        Person.create({
            name: req.body.name,
            birthdate: req.body.birthdate,
            address: req.body.address,
            phone: req.body.phone,
            email: req.body.email,
            bi: req.body.bi,
            nif: req.body.nif,
            gender: req.body.gender,
            state: "registered",
            userId: req.user.id
        })
        .then(r => {
            return res.redirect(`/details/${r.id}`)
        })
        .catch(e => logger.error(e))
    }
})

app.get("/pessoas/:category", (req, res) => {
    log(req, res)
    if (!req.user) return res.redirect("/login")

    let context = {
        user: req.user,
        admin: req.user.group === 'admin',
        avaliador: req.user.group === 'avaliador'
    }

    let category = req.params.category
    switch (category) {
        case "indb":
            context.pageTitle = "Pessoas na Base de Dados"
            Person.findAll()
            .then(r => {
                context.person = utils.changeSG(r)
                res.render("list", context)
            })
            .catch(e => logger.error(e))
            break

        case "regi":
            context.pageTitle = "Pessoas Apenas Registradas"
            Person.findAll({
                where: { state: "registered" }
            })
            .then(r => {
                context.person = utils.changeSG(r)
                res.render("list", context)
            })
            .catch(e => logger.error(e))
            break

        case "wait":
            context.pageTitle = "Pessoas a espera de Formação"
            Person.findAll({
                where: { state: 'waiting_formation'}
            })
            .then(r => {
                context.person = utils.changeSG(r)
                res.render('list', context)
            })
            .catch(e => logger.error(e))
            break

        case "form":
            context.pageTitle = "Pessoas em Formação"
            Person.findAll({
                where: { state: "formation" }
            })
            .then(r => {
                context.person = utils.changeSG(r)
                res.render("list", context)
            })
            .catch(e => logger.error(e))
            break

        case "inte":
            context.pageTitle = "Pessoas em Estágio"
            Person.findAll({
                where: { state: "internship" }
            })
            .then(r => {
                context.person = utils.changeSG(r)
                res.render("list", context)
            })
            .catch(e => logger.error(e))
            break

        case "hire":
            context.pageTitle = "Pessoas Colocadas"
            Person.findAll({
                where: { state: "hired" }
            })
            .then(r => {
                context.person = utils.changeSG(r)
                res.render("list", context)
            })
            .catch(e => logger.error(e))
            break

        case "rese":
            context.pageTitle = "Pessoas em Reserva"
            Person.findAll({
                where: { state: "reserved" }
            })
            .then(r => {
                context.person = utils.changeSG(r)
                res.render("list", context)
            })
            .catch(e => logger.error(e))
            break

        case "eval":
            context.pageTitle = "Pessoas Avaliadas"
            Person.findAll({
                where: {
                    score: {
                        [Sequelize.Op.ne]: null
                    }
                }
            })
            .then(r => {
                context.person = utils.changeSG(r)
                res.render("list_eval", context)
            })
            .catch(e => logger.error(e))
            break

        case "gave":
            context.pageTitle = "Pessoas que desistiram"
            Person.findAll({
                where: { state: 'gave_up'}
            })
            .then(r => {
                context.person = utils.changeSG(r)
                res.render("list", context)
            })
            .catch(e => logger.error(e))
            break

        default:
            res.redirect("/")
    }
})

app.get("/details/:userId(\\d+)", (req, res) => {
    log(req, res)
    if (!req.user) return res.redirect("/login")

    let options = {
        user: req.user,
        admin: req.user.group === 'admin',
        avaliador: req.user.group === 'avaliador'
    }

    Person.findByPk(req.params.userId)
    .then(r => {
        Object.assign(options, {
            pageTitle: r.name,
            person: utils.changeSG(r),
            birthdate: utils.getProperDate(r.birthdate)
        });
        return r.getFormations()
    })
    .then(fs => {
        options.formation = fs
        return User.findOne({
            where: {
                id: options.person.userId
            }
        })
    })
    .then(u => {
        options.createdBy = u.username
        return res.render("details", options)
    })
    .catch(e => logger.error(e))
})

app.get("/edit/:userId(\\d+)", (req, res) => {
    log(req, res)
    if (!req.user || req.user.group === 'avaliador') return res.redirect("/login")

    let context = {}
    Person.findByPk(req.params.userId)
    .then(r => {
        Object.assign(context, {
            pageTitle: r.name,
            person: r,
            birthdate: utils.getProperDate(r.birthdate),
            user: req.user,
            admin: req.user.group === "admin"
        });
        return r.getFormations()
    })
    .then(fs => {
        context.formation = fs;
        return res.render("edit", context)
    })
    .catch(e => logger.error(e))
})

app.post("/edit/:userId(\\d+)", [
    check("name").isString(),
    check("birthdate").matches(/^\d{4}-\d{2}-\d{2}$/),
    check("phone").isMobilePhone(),
    check("bi").isNumeric(),
    check("nif").isNumeric(),
    check("gender").isIn(["male", "female"]),
    check("state").isIn(["registered", "waiting_formation", "formation", "internship", "hired", "reserved", 'gave_up'])
], (req, res) => {
    log(req, res)
    if (!req.user || req.user.group === 'avaliador') return res.redirect("/login")

    const errors = validationResult(req)
    if (!errors.isEmpty()) {
        Person.findByPk(req.params.userId)
        .then(r => {
            return res.render("edit", {
                pageTitle: r.name,
                person: r,
                birthdate: utils.getProperDate(r.birthdate),
                error: utils.changeError(errors.array()[0])
            })
        })
        .catch(e => logger.error(e))
    }

    let buffer = {}
    Person.update({
        name: req.body.name,
        birthdate: req.body.birthdate,
        address: req.body.address,
        phone: req.body.phone,
        email: req.body.email,
        bi: req.body.bi,
        nif: req.body.nif,
        gender: req.body.gender,
        state: req.body.state,
        userId: req.user.id
    }, {
        where: {
            id: req.params.userId
        }
    })
    .then(() => {
        return Person.findByPk(req.params.userId)
    })
    .then(p => {
        buffer.p = p
        return p.getFormations()
    })
    .then(fs => {
        let formations = []
        for (f of fs) {
            if (req.body[f.id] === "on") {
                formations.push(f.id)
            }
        }
        buffer.formations = fs.filter(el => req.body[el.id] === 'on')
        return buffer.p.setFormations(formations)
    })
    .then(() => {
        return Payment.findOne({
            where: {
                personId: buffer.p.id
            }
        })
    })
    .then(p => {
        let total = 0
        for (f of buffer.formations) {
            total += f.subscription_cost + f.certificate_cost
        }
        if (p) {
            total *= (100 - p.discount) / 100
            return p.update({
                toPay: total
            })
        } else {
            return new Promise((resolve, reject) => {resolve()})
        }
    })
    .then(() => res.redirect(`/details/${req.params.userId}`))
    .catch(e => logger.error(e))
});

app.get("/avaliar/:userId(\\d+)", (req, res) => {
    log(req, res)
    if (!req.user) return res.redirect("/login")

    Person.findByPk(req.params.userId)
    .then(r => {
        res.render("avaliar", {
            pageTitle: "Avaliação do Estagiário",
            person: r,
            user: req.user,
            admin: req.user.group === "admin",
            avaliador: req.user.group === 'avaliador'
        })
    })
    .catch(e => logger.error(e))
})

app.post("/avaliar/:userId(\\d+)", [
    check("shop").isString(),
    check("shift_from").matches(/^\d{2}:\d{2}$/),
    check("shift_to").matches(/^\d{2}:\d{2}$/),
    check("shop_number").isInt(),
    check("date_from").matches(/^\d{4}-\d{2}-\d{2}$/),
    check("date_to").matches(/^\d{4}-\d{2}-\d{2}$/),
    check("cachier").isInt({ min: 1, max: 5 }),
    check("cleaning").isInt({ min: 1, max: 5 }),
    check("customer_service").isInt({ min: 1, max: 5 }),
    check("replacement").isInt({ min: 1, max: 5 }),
    check("team_work").isInt({ min: 1, max: 5 }),
    check("cold_meats").isInt({ min: 1, max: 5 }),
    check("flexibility").isInt({ min: 1, max: 5 }),
    check("autonomy").isInt({ min: 1, max: 5 }),
    check("punctuality").isInt({ min: 1, max: 5 }),
    check("honesty").isInt({ min: 1, max: 5 }),
    check("proactivity").isInt({ min: 1, max: 5 }),
    check("responsability").isInt({ min: 1, max: 5 }),
    check("interest_level").isInt({ min: 1, max: 5 }),
    check("availability").isInt({ min: 1, max: 5 }),
    check("personal_hygiene").isInt({ min: 1, max: 5 }),
    check("responsible_hr").isString(),
    check("advisor").isString()
], (req, res) => {
    log(req, res)
    if (!req.user) return res.redirect("/login")

    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        Person.findByPk(req.params.userId)
        .then(r => {
            return res.render(`avaliar`, {
                pageTitle: "Avaliação do Estagiário",
                error: utils.changeError(errors.array()[0]),
                form_data: req.body,
                person: r,
                user: req.user,
                admin: req.user.group === 'admin',
                avaliador: req.user.group === 'avaliador'
            })
        })
        .catch(e => logger.error(e))
    } else {
        Evaluation.create({
            shop: req.body.shop,
            shift_from: req.body.shift_from,
            shift_to: req.body.shift_to,
            shop_number: req.body.shop_number,
            date_from: req.body.date_from,
            date_to: req.body.date_to,
            cachier: req.body.cachier,
            cleaning: req.body.cleaning,
            customer_service: req.body.customer_service,
            replacement: req.body.replacement,
            team_work: req.body.team_work,
            cold_meats: req.body.cold_meats,
            flexibility: req.body.flexibility,
            autonomy: req.body.autonomy,
            punctuality: req.body.punctuality,
            honesty: req.body.honesty,
            proactivity: req.body.proactivity,
            responsability: req.body.responsability,
            interest_level: req.body.interest_level,
            availability: req.body.availability,
            personal_hygiene: req.body.personal_hygiene,
            obs: req.body.obs,
            responsible_hr: req.body.responsible_hr,
            advisor: req.body.advisor,
            personId: req.params.userId,
            userId: req.user.id
        })
        .then(ev => {
            // Fazer update do score em Person.score e Person.scoreText
            return Promise.all([
                Evaluation.findAll({where: {personId: req.params.userId}}),
                Discount.findAll({where: {personId: req.params.userId}}),
                Increase.findAll({where: {personId: req.params.userId}})
            ])
        })
        .then(r => {
            utils.setScore(r[0], r[1], r[2])
            return Person.update({
                score: r[0].media,
                scoreText: r[0].mediaText
            }, {
                where: {
                    id: req.params.userId
                }
            })
        })
        .then(r => {
            return res.redirect(`/avaliado/${req.params.userId}`)
        })
        .catch(e => logger.error(e))
    }
})

app.get("/avaliado/:userId(\\d+)", (req, res) => {
    log(req, res)
    if (!req.user) return res.redirect("/login")

    let options = null
    Person.findByPk(req.params.userId)
    .then(person => {
        options = {
            pageTitle: `Avaliações de ${person.name}`,
            person,
            user: req.user,
            admin: req.user.group === "admin",
            avaliador: req.user.group === 'avaliador'
        }
        return Promise.all([
            person.getEvaluations(),
            Discount.findAll({
                where: {
                    personId: req.params.userId
                }
            }),
            Increase.findAll({
                where: {
                    personId: req.params.userId
                }
            })
        ])
    })
    .then(r => {
        Object.assign(options, {
            evaluations: utils.setScore(r[0], r[1], r[2]),
            discount: r[1],
            increase: r[2]
        })
        return res.render("avaliado", options)
    })
    .catch(e => logger.error(e))
})

app.get("/avaliar_edit/:av_id(\\d+)", (req, res) => {
    log(req, res)
    if (!req.user) return res.redirect("/login")

    let options = {
        pageTitle: "Avaliação do Estágiario",
        user: req.user,
        admin: req.user.group === "admin",
        avaliador: req.user.group === 'avaliador'
    }
    Evaluation.findByPk(req.params.av_id)
    .then(av => {
        options.evaluations = av
        return Person.findByPk(av.dataValues.personId)
    })
    .then(person => {
        options.person = person
        return res.render("avaliar_edit", options)
    })
    .catch(e => logger.error(e))
})

app.post("/avaliar_edit/:av_id(\\d+)", [
    check("shop").isString(),
    check("shift_from").matches(/^\d{2}:\d{2}:\d{2}$/),
    check("shift_to").matches(/^\d{2}:\d{2}:\d{2}$/),
    check("shop_number").isInt(),
    check("date_from").matches(/^\d{4}-\d{2}-\d{2}$/),
    check("date_to").matches(/^\d{4}-\d{2}-\d{2}$/),
    check("cachier").isInt({ min: 1, max: 5 }),
    check("cleaning").isInt({ min: 1, max: 5 }),
    check("customer_service").isInt({ min: 1, max: 5 }),
    check("replacement").isInt({ min: 1, max: 5 }),
    check("team_work").isInt({ min: 1, max: 5 }),
    check("cold_meats").isInt({ min: 1, max: 5 }),
    check("flexibility").isInt({ min: 1, max: 5 }),
    check("autonomy").isInt({ min: 1, max: 5 }),
    check("punctuality").isInt({ min: 1, max: 5 }),
    check("honesty").isInt({ min: 1, max: 5 }),
    check("proactivity").isInt({ min: 1, max: 5 }),
    check("responsability").isInt({ min: 1, max: 5 }),
    check("interest_level").isInt({ min: 1, max: 5 }),
    check("availability").isInt({ min: 1, max: 5 }),
    check("personal_hygiene").isInt({ min: 1, max: 5 }),
    check("responsible_hr").isString(),
    check("advisor").isString()
], (req, res) => {
    log(req, res)
    if (!req.user) return res.redirect("/login")

    const errors = validationResult(req)
    if (!errors.isEmpty()) {
        let options = { 
            pageTitle: "Avaliação do Estágiario",
            user: req.user,
            admin: req.user.group === 'admin',
            avaliador: req.user.group === 'avaliador'
        }
        Evaluation.findByPk(req.params.av_id)
        .then(av => {
            options.evaluations = av
            return Person.findOne(av.dataValues.personId)
        })
        .then(person => {
            options.person = person
            options.error = utils.changeError(errors.array()[0])
            return res.render("avaliar_edit", options)
        })
        .catch(e => logger.error(e))
    } else {
        Evaluation.update({
            shop: req.body.shop,
            shift_from: req.body.shift_from,
            shift_to: req.body.shift_to,
            shop_number: req.body.shop_number,
            date_from: req.body.date_from,
            date_to: req.body.date_to,
            cachier: req.body.cachier,
            cleaning: req.body.cleaning,
            customer_service: req.body.customer_service,
            replacement: req.body.replacement,
            team_work: req.body.team_work,
            cold_meats: req.body.cold_meats,
            flexibility: req.body.flexibility,
            autonomy: req.body.autonomy,
            punctuality: req.body.punctuality,
            honesty: req.body.honesty,
            proactivity: req.body.proactivity,
            responsability: req.body.responsability,
            interest_level: req.body.interest_level,
            availability: req.body.availability,
            personal_hygiene: req.body.personal_hygiene,
            obs: req.body.obs,
            responsible_hr: req.body.responsible_hr,
            advisor: req.body.advisor,
            personId: req.body.personId,
            userId: req.user.id
        }, {
            where: {
                id: req.params.av_id
            }
        })
        .then(() => {
            // Fazer update do score em Person.score e Person.scoreText
            return Promise.all([
                Evaluation.findAll({ where: { personId: req.body.personId }}),
                Discount.findAll({where: {personId: req.params.personId}}),
                Increase.findAll({where: {personId: req.params.personId}})
            ])
        })
        .then(r => {
            utils.setScore(r[0], r[1], r[2])
            return Person.update({
                score: r[0].media,
                scoreText: r[0].mediaText
            }, {
                where: {
                    id: req.body.personId
                }
            })
        })
        .then(r => {
            return res.redirect(`/avaliado/${req.body.personId}`)
        })
        .catch(e => logger.error(e))
    }
})

app.get("/admin", (req, res) => {
    log(req, res)
    if (!req.user || req.user.group !== "admin") return res.redirect("/login")

    User.findAll()
    .then(r => {
        return res.render("admin", {
            pageTitle: "Administração",
            person: r,
            user: req.user,
            admin: req.user.group === "admin"
        })
    })
    .catch(e => logger.error(e))
})

app.get("/create_user", (req, res) => {
    log(req, res)
    if (!req.user && req.user.group !== "admin") return res.redirect("/login")

    res.render("create_user", {
        pageTitle: "Criar Utilizador",
        user: req.user,
        admin: req.user.group === "admin"
    })
})

app.post("/create_user", [
    check("username").matches(/^[a-zA-Z0-9_.-]+$/),
    check("group").isIn(["admin", "regular", "avaliador"]),
    check("password").isLength({ min: 6 })
], (req, res) => {
    log(req, res)
    if (!req.user && req.user.group !== "admin") return res.redirect("/login")

    const errors = validationResult(req)
    if (!errors.isEmpty()) {
        return res.render("create_user", {
            pageTitle: "Criar Utilizador",
            error: utils.changeError(errors.array()[0]),
            form_data: req.body
        })
    }

    if (req.body.password !== req.body.confirm_password) {
        return res.render("create_user", {
            pageTitle: "Criar Utilizador",
            error: {
                param: "Senhas",
                msg: "não são iguais"
            },
            form_data: req.body
        })
    }

    User.findAndCount({
        where: {
            username: req.body.username
        }
    })
    .then(r => {
        if (r.count > 0) {
            return res.render("create_user", {
                pageTitle: "Criar Utilizador",
                error: {
                    param: "Nome de Utilizador",
                    msg: "já foi tomado"
                },
                form_data: req.body
            })
        }

        User.create({
            username: req.body.username,
            group: req.body.group,
            password: bcrypt.hashSync(req.body.password)
        })
        .then(() => {
            return res.redirect("/admin")
        })
    })
    .catch(e => logger.error(e))
})

app.get("/login", (req, res) => {
    log(req, res)
    if (req.user) return res.redirect("/")
    res.render("login", { pageTitle: "Entrar" })
})

app.post("/login", (req, res, next) => {
    log(req, res)
    passport.authenticate("local", (err, user, info) => {
        if (info) {
            let options = {
                pageTitle: "Entrar"
            }
            if (info.message) {
                options.error = {
                    param: "Credenciais",
                    msg: "Invalidos"
                }
            } else {
                options.error = info
            }
            return res.render("login", options)
        }

        if (err) {
            return next(err)
        }

        if (!user) {
            return res.redirect("/login")
        }

        req.login(user, err => {
            if (err) return next(err)
            return res.redirect("/")
        })
    })(req, res, next)
})

app.get("/logout", function(req, res) {
    log(req, res)
    req.logout()
    res.redirect("/login")
})

app.get("/delete_user/:userId", (req, res) => {
    log(req, res)
    if (!req.user || req.user.group !== 'admin') return res.redirect("/login")

    User.destroy({
        where: {
            id: req.params.userId
        }
    }).then(() => {
        return res.redirect("/admin")
    })
    .catch(e => logger.error(e))
})

app.get("/delete_person/:userId/:category", (req, res) => {
    log(req, res)
    if (!req.user || req.user.group !== "admin") return res.redirect("/login")
  
    Person.destroy({
        where: {
            id: req.params.userId
        }
    })
    .then(() => {
        return res.redirect(`/pessoas/${req.params.category}`)
    })
    .catch(e => logger.error(e))
})

app.get("/delete_evaluation/:av_id/:userId", (req, res) => {
    log(req, res)
    if (!req.user || req.user.group !== "admin") return res.redirect("/login")

    Evaluation.destroy({
        where: {
            id: req.params.av_id
        }
    })
    .then(() => {
        return res.redirect(`/avaliado/${req.params.userId}`)
    })
    .catch(e => logger.error(e))
})

app.get('/delete_formation/:f_id(\\d+)', (req, res) => {
    log(req, res)
    if (!req.user || req.user.group !== 'admin') return res.redirect('/login')

    Formation.destroy({
        where: {
            id: req.params.f_id
        }
    })
    .then(() => {
        return res.redirect('/formations')
    })
    .catch(e => logger.error(e))
})

app.get("/formations", (req, res) => {
    log(req, res)
    if (!req.user || req.user.group !== "admin") return res.redirect("/login")

    Formation.findAll()
    .then(fs => {
        res.render("formations", {
            pageTitle: "Formações Disponiveis",
            formations: fs,
            user: req.user,
            admin: req.user.group === 'admin'
        })
    })
    .catch(e => logger.error(e))
})

app.get("/add_formation", (req, res) => {
    log(req, res)
    if (!req.user || req.user.group !== "admin") return res.redirect("/login")
    
    res.render("add_formation", {
        pageTitle: "Registar Formação",
        user: req.user,
        admin: req.user.group === 'admin'
    })
})

app.post("/add_formation", [
    check("name").isString(),
    check("teoric_part").isNumeric(),
    check("pratic_part").isNumeric(),
    check("subscription_cost").isNumeric(),
    check("certificate_cost").isNumeric()
], (req, res) => {
    log(req, res)
    if (!req.user || req.user.group !== "admin") return res.redirect("/login")

    const errors = validationResult(req)
    if (!errors.isEmpty()) {
        return res.render("add_formation", {
            pageTitle: "Registar Formação",
            error: utils.changeError(errors.array()[0]),
            form_data: req.body
        })
    } else {
        Formation.create({
            name: req.body.name,
            description: req.body.description,
            teoric_part: req.body.teoric_part,
            pratic_part: req.body.pratic_part,
            subscription_cost: req.body.subscription_cost,
            certificate_cost: req.body.certificate_cost
        })
        .then(r => {
            return res.redirect("/formations")
        })
        .catch(e => logger.error(e))
    }
})

app.get("/formation/:fid(\\d+)", (req, res) => {
    log(req, res)
    if (!req.user || req.user.group !== "admin") return res.redirect("/login")

    Formation
    .findByPk(req.params.fid)
    .then(f => {
        return res.render("formation_edit", {
            pageTitle: "Editar Formação",
            formation: f.dataValues
        })
    })
    .catch(e => logger.error(e))
})

app.post("/formation/:fid(\\d+)", [
    check("name").matches(/.+/),
    check("teoric_part").isNumeric(),
    check("pratic_part").isNumeric(),
    check("subscription_cost").isNumeric(),
    check("certificate_cost").isNumeric()
], (req, res) => {
    log(req, res)
    if (!req.user || req.user.group !== "admin") return res.redirect("/login")

    const errors = validationResult(req)
    if (!errors.isEmpty()) {
        return res.render("formation_edit", {
            pageTitle: "Editar Formação",
            formation: f.dataValues,
            error: utils.changeError(errors.array()[0])
        })
    } else {
        Formation
        .update({
            name: req.body.name,
            teoric_part: req.body.teoric_part,
            pratic_part: req.body.pratic_part,
            subscription_cost: req.body.subscription_cost,
            certificate_cost: req.body.certificate_cost,
            description: req.body.description
        }, {
            where: {
                id: req.params.fid
            }
        })
        .then(r => {
            return res.redirect("/formations")
        })
        .catch(e => logger.error(e))
    }
})

app.get("/choose_formation/:personId", (req, res) => {
    log(req, res)
    if (!req.user || req.user.group === 'avaliador') return res.redirect("/login")

    let context = {
        user: req.user,
        admin: req.user.group === 'admin'
    }
    Formation
    .findAll()
    .then(fs => {
        context.formation = fs
        return Person.findByPk(req.params.personId)
    })
    .then(p => {
        context.pageTitle = `Escolhe Formações para ${p.name}`
        context.personId = p.id
        return p.getFormations()
    })
    .then(fs => {
        context.formation = context.formation.filter(el => {
            for (element of fs) {
                if (element.id === el.id) {
                    return false;
                }
            }
            return true
        })
        res.render("choose_formation", context)
    })
    .catch(e => logger.error(e))
})

app.post("/choose_formation/:personId", (req, res) => {
    log(req, res)
    if (!req.user || req.user.group === 'avaliador') return res.redirect("/login")

    let context = {}
    Person
    .findByPk(req.params.personId)
    .then(p => {
        context.p = p
        return Formation.findAll()
    })
    .then(fs => {
        formations = [];
        for (formation of fs) {
            if (req.body[formation.id] === "on") {
                formations.push(formation.id)
            }
        }
        return context.p.addFormations(formations)
    })
    .then(() => {
        context.p.state = "formation"
        return context.p.save()
    })
    .then(() => {
        return context.p.getFormations()
    })
    .then(fs => {
        context.formations = fs
        return Payment.findOne({
            where: {
                personId: req.params.personId
            }
        })
    })
    .then(p => {
        let total = 0
        for (el of context.formations) {
            total += el.subscription_cost + el.certificate_cost
        }
        total *= (100 - parseFloat(req.body.discount)) / 100

        if (p) {
            return p.update({
                toPay: total,
                discount: req.body.discount
            })
        }
        
        return Payment.create({
            toPay: total,
            paid: 0,
            discount: req.body.discount,
            personId: context.p.id
        })
    })
    .then(p => res.redirect(`/details/${req.params.personId}`))
    .catch(e => logger.error(e))
})

app.get('/payment/:personId', (req, res) => {
    log(req, res)
    if (!req.user || req.user.group === 'avaliador') return res.redirect('/login')

    let context = {
        pageTitle: 'Pagamento',
        user: req.user,
        admin: req.user.group === 'admin'
    }
    Person
    .findByPk(req.params.personId)
    .then(pe => {
        context.person = pe
        return Payment.findOne({
            where: {
                personId: req.params.personId
            }
        })
    })
    .then(pa => {
        context.payment = pa
        context.debt = pa.toPay - pa.paid
        context.date = new Date().toLocaleDateString()
        return res.render('payment', context)
    })
    .catch(e => logger.error(e))
})

app.post('/payment/:personId', (req, res) => {
    log(req, res)
    if (!req.user || req.user.group === 'avaliador') return res.redirect('/login')

    Payment
    .findOne({
        where: {
            personId: req.params.personId
        }
    })
    .then(pa => {
        return pa.update({
            paid: pa.paid + parseFloat(req.body.quantity)
        })
    })
    .then(() => {
        return res.redirect(`/payment/${req.params.personId}`)
    })
    .catch(e => logger.error(e))
})

app.get('/discount_person/:personId(\\d+)', (req, res) => {
    log(req, res)
    if (!req.user) return res.redirect('/login')

    Person
    .findByPk(req.params.personId)
    .then(person => {
        return res.render('discount_person', {
            person,
            pageTitle: `Descontar de ${person.name}`,
            user: req.user,
            admin: req.user.group === 'admin',
            avaliador: req.user.group === 'avaliador'
        })
    })
    .catch(e => logger.error(e))
})

app.post('/discount_person/:personId(\\d+)', [
    check('quantity').isFloat()
], (req, res) => {
    log(req, res)
    if (!req.user) return res.redirect('/login')

    let errors = validationResult(req)
    if (!errors.isEmpty()) {
        Person
        .findByPk(req.params.personId)
        .then(person => {
            return res.render('discount_person', {
                error: utils.changeError(errors.array()[0]),
                pageTitle: `Descontar de ${person.name}`,
                person,
                user: req.user,
                admin: req.user.group === 'admin',
                avaliador: req.user.group === 'avaliador'
            })
        })
        .catch(e => logger.error(e))
    } else {
        Discount
        .create({
            quantity: Math.abs(req.body.quantity),
            reason: req.body.reason,
            personId: req.params.personId,
            userId: req.user.id
        })
        .then(() => {
            return Promise.all([
                Evaluation.findAll({where: {personId: req.params.personId}}),
                Discount.findAll({where: {personId: req.params.personId }}),
                Increase.findAll({where: {personId: req.params.personId }})
            ])
        })
        .then(r => {
            utils.setScore(r[0], r[1], r[2])
            return Person.update({
                score: r[0].media,
                scoreText: r[0].mediaText
            }, {
                where: {id: req.params.personId}
            })
        })
        .then(() => {
            return res.redirect('/avaliado/' + req.params.personId)
        })
        .catch(e => logger.error(e))
    }
})

app.get('/delete_discount/:dis_id/:personId', (req, res) => {
    log(req, res)
    if (!req.user || req.user.group !== 'admin') return res.redirect('/login')

    Discount
    .destroy({
        where: {
            id: req.params.dis_id
        }
    })
    .then(() => {
        return Promise.all([
            Evaluation.findAll({where: {personId: req.params.personId}}),
            Discount.findAll({where: {personId: req.params.personId}}),
            Increase.findAll({where: {personId: req.params.personId}})
        ])
    })
    .then(r => {
        utils.setScore(r[0], r[1], r[2])
        return Person.update({
            score: r[0].media,
            scoreText: r[0].mediaText
        }, {
            where: {id: req.params.personId}
        })
    })
    .then(() => {
        return res.redirect(`/avaliado/${req.params.personId}`)
    })
    .catch(e => logger.error(e))
})

app.get('/increase_person/:personId(\\d+)', (req, res) => {
    log(req, res)
    if (! req.user) return res.redirect('/login')

    Person
    .findByPk(req.params.personId)
    .then(person => {
        return res.render('increase_person', {
            pageTitle: `Aumento de ${person.name}`,
            user: req.user,
            admin: req.user.group === 'admin',
            person,
            avaliador: req.user.group === 'avaliador'
        })
    })
    .catch(e => logger.error(e))
})

app.post('/increase_person/:personId(\\d+)', [
    check('quantity').isFloat()
], (req, res) => {
    log(req, res)
    if (! req.user) return res.redirect('/login')

    let errors = validationResult(req)
    if (!errors.isEmpty()) {
        Person
        .findByPk(req.params.personId)
        .then(person => {
            return res.render('increase_person', {
                pageTitle: `Aumento de ${person.name}`,
                user: req.user,
                admin: req.user.group === 'admin',
                person,
                error: utils.changeError(errors.array()[0]),
                avaliador: req.user.group === 'avaliador'
            })
        })
        .catch(e => logger.error(e))
    } else {
        Increase
        .create({
            quantity: Math.abs(req.body.quantity),
            reason: req.body.reason,
            personId: req.params.personId,
            userId: req.user.id
        })
        .then(() => {
            return Promise.all([
                Evaluation.findAll({where: {personId: req.params.personId}}),
                Discount.findAll({where: {personId: req.params.personId}}),
                Increase.findAll({where: {personId: req.params.personId}})
            ])
        })
        .then(r => {
            utils.setScore(r[0], r[1], r[2])
            return Person.update({
                score: r[0].media,
                scoreText: r[0].mediaText
            }, {
                where: {id: req.params.personId}
            })
        })
        .then(() => {
            return res.redirect(`/avaliado/${req.params.personId}`)
        })
        .catch(e => logger.error(e))
    }
})

app.get('/delete_increase/:inc_id/:personId', (req, res) => {
    log(req, res)
    if (!req.user || req.user.group !== 'admin') return res.redirect('/login')

    Increase
    .destroy({
        where: {
            id: req.params.inc_id
        }
    })
    .then(() => {
        return Promise.all([
            Evaluation.findAll({where: {personId: req.params.personId}}),
            Discount.findAll({where: {personId: req.params.personId}}),
            Increase.findAll({where: {personId: req.params.personId}})
        ])
    })
    .then(r => {
        utils.setScore(r[0], r[1], r[2])
        return Person.update({
            score: r[0].media,
            scoreText: r[0].mediaText
        }, {
            where: {id: req.params.personId}
        })
    })
    .then(() => {
        return res.redirect(`/avaliado/${req.params.personId}`)
    })
    .catch(e => logger.error(e))
})

app.get('/pre_registration', (req, res) => {
    log(req, res)
    res.render('pre_registration')
})

app.post('/pre_registration', [
    check('name').isString(),
    check('phone').isString(),
    check('email').isEmail()
], (req, res) => {
    log(req, res)
    const errors = validationResult(req)
    if(!errors.isEmpty()) {
        return res.render('pre_registration', {
            error: utils.changeError(errors.array()[0])
        })
    }

    PreRegister
    .create({
        name: req.body.name,
        address: req.body.address,
        phone: req.body.phone,
        email: req.body.email
    })
    .then(() => {
        return res.render('pre_registration', {
            success: {msg: 'Pré incrição efectuada com sucesso!'}
        })
    })
    .catch(e => logger.error(e))
})

app.get('/pre_inscritos', async (req, res) => {
    log(req, res)
    if(!req.user || req.user.group === 'avaliador') return res.redirect('/login')
    const person = await PreRegister.findAll()
    res.render('pre_inscritos', {
        person,
        user: req.user,
        admin: req.user.group === 'admin',
        pageTitle: 'Pré Inscritos'
    })
})

app.get('/delete_pre_inscrito/:id', (req, res) => {
    log(req, res)
    if(!req.user || req.user.group === 'avaliador') return res.redirect('/login')
    PreRegister
    .destroy({where: {id: req.params.id}})
    .then(() => {
        return res.redirect('/pre_inscritos')
    })
    .catch(e => logger.error(e))
})

app.listen(port, "0.0.0.0", () => {
    logger.info(`Server started at port ${port}`)
})
