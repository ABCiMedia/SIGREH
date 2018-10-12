const express = require("express"),
  hbs = require("hbs"),
  { check, validationResult } = require("express-validator/check"),
  passport = require("passport"),
  LocalStrategy = require("passport-local").Strategy,
  session = require("express-session"),
  uuid = require("uuid/v4"),
  bcrypt = require("bcrypt-nodejs"),
  MySQLStore = require("express-mysql-session")(session),
  Sequelize = require('sequelize');

const { Person } = require("./models/Person"),
  { Evaluation } = require("./models/Evaluation"),
  { User } = require('./models/User'),
  { Formation } = require('./models/Formation'),
  utils = require("./utils"),
  cred = require("./models/credentials");

///// CONFIGURING PASSPORT WITH LOCAL STRATEGY
passport.use(
  new LocalStrategy((username, password, done) => {
    User.find({ where: { username } })
      .then(u => {
        if (!u) {
          return done(null, false, { param: "Credenciais", msg: "Invalidas" });
        }
        if (!bcrypt.compareSync(password, u.dataValues.password)) {
          return done(null, false, { param: "Credenciais", msg: "Invalidas" });
        }
        return done(null, u.dataValues);
      })
      .catch(err => done({ param: "Credenciais", msg: "Invalidas" }));
  })
);

passport.serializeUser((user, done) => {
  done(null, user.id);
});

passport.deserializeUser((id, done) => {
  User.findById(id)
    .then(res => {
      user = res ? res.dataValues : false;
      done(null, user);
    })
    .catch(error => done(error, false));
});

const app = express();
const port = process.env.PORT || 3000;

app.set("view engine", "hbs");
hbs.registerPartials(__dirname + "/views/partials");

/////// HELPERS

hbs.registerHelper('ifCond', (v1, v2, options) => {
  if (v1 === v2) {
    return options.fn(v1);
  } else {
    return options.inverse(v1);
  }
});

hbs.registerHelper("select", (name, selected, options) => {
  options = JSON.parse(options);
  let result = `<select name='${name}'>`;
  result += `<option value='${selected}' selected>${utils.portMap.get(
    selected
  )}</option>`;

  for (key in options) {
    if (key !== selected) {
      result += `<option value='${key}'>${options[key]}</option>`;
    }
  }
  result += "</select>";
  return result;
});

hbs.registerHelper("radio", function(name, context) {
  let result = "";
  checked = this.hasOwnProperty(context) ? parseInt(this[context][name]) : null;

  for (let i = 1; i <= 5; i++) {
    if (i === checked) {
      result += `<input type='radio' name='${name}' value=${i} checked>\n`;
    } else {
      result += `<input type='radio' name='${name}' value=${i}>\n`;
    }
  }
  return new hbs.SafeString(result.slice(0, -1) + "<br>");
});

//////// MIDLEWARES

app.use((req, res, next) => {
  var now = new Date().toString();
  console.log(now, req.method, req.url, res.statusCode);
  next();
});
app.use(express.static(__dirname + "/public"));
app.use(express.urlencoded({ extended: false }));
app.use(express.json());
app.use(
  session({
    secret: "This is the secret key",
    genid: () => uuid(),
    store: new MySQLStore({
      database: cred.database,
      user: cred.username,
      password: cred.password,
      host: cred.host,
      port: 3306
    }),
    saveUninitialized: true,
    resave: false
  })
);
app.use(passport.initialize());
app.use(passport.session());

/////// HANDLERS

app.get("/", (req, res) => {
  if (!req.user) {
    return res.redirect('/login');
  }
  let options = {};
  options.user = req.user;
  options.admin = req.user.group === 'admin' ? true : false;
  options.pageTitle = "Painel de Controlo";
  Person.findAndCountAll()
    .then(r => {
      options.peopleInDB = r.count;
      return Person.findAndCountAll({
        where: {
          state: "registered"
        }
      });
    })
    .then(r => {
      options.peopleRegistered = r.count;
      return Person.findAndCountAll({
        where: {
          state: "formation"
        }
      });
    })
    .then(r => {
      options.peopleFormating = r.count;
      return Person.findAndCountAll({
        where: {
          state: "internship"
        }
      });
    })
    .then(r => {
      options.peopleInInternship = r.count;
      return Person.findAndCountAll({
        where: {
          state: "hired"
        }
      });
    })
    .then(r => {
      options.peopleHired = r.count;
      return Person.findAndCountAll({
        where: {
          state: "reserved"
        }
      });
    })
    .then(r => {
      options.peopleReserved = r.count;
      return Person.findAndCountAll({
        where: {
          score: {
            [Sequelize.Op.ne]: null
          }
        }
      });
    })
    .then(r => {
      options.peopleEvaluated = r.count;
      return res.render("dashboard", options);
    })
    .catch(e => {
      console.log(e);
    });
});

app.get("/inscrever", (req, res) => {
  if (!req.user) {
    return res.redirect('/login');
  }
  let options = {};
  options.user = req.user;
  options.admin = req.user.group === 'admin' ? true : false;
  options.pageTitle = 'Inscrições'
  return res.render("register", options);
});

app.post("/inscrever", [
    check("name").matches(/^[a-zA-Z0-9_ .]+$/),
    check("birthdate").isBefore(new Date().toLocaleDateString()),
    check("phone").isMobilePhone(),
    check("email").isEmail(),
    check("bi").matches(/^\d{4,7}$/),
    check("nif").matches(/^\d{6,10}$/),
    check("gender").isIn(["male", "female"])
  ], (req, res) => {
    if (!req.user) {
      return res.redirect('/login');
    }
    let options = {};
    options.user = req.user;
    options.admin = req.user.group === 'admin' ? true : false;
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      let options = {
        pageTitle: "Inscrições",
        error: utils.changeError(errors.array()[0]),
        form_data: req.body
      };
      return res.render("register.hbs", options);
    } else {
      Person.create({
        name: req.body.name,
        birthdate: req.body.birthdate,
        address: req.body.address,
        phone: req.body.phone,
        email: req.body.email,
        bi: parseInt(req.body.bi),
        nif: parseInt(req.body.nif),
        gender: req.body.gender,
        state: "registered",
        userId: req.user.id,
      }).then(r => {
        return res.redirect(`/details/${r.id}`);
      });
    }
  }
);

app.get("/pessoas/:category", (req, res) => {
  if (!req.user) {
    return res.redirect('/login');
  }
  let context = {};
  context.user = req.user;
  context.admin = req.user.group === 'admin' ? true : false;
  let category = req.params.category;
  switch (category) {
    case "indb":
      context.pageTitle = "Pessoas na Base de Dados";
      Person.findAll().then(r => {
        context.person = utils.changeSG(r);
        res.render("list", context);
      });
      break;
    case "regi":
      context.pageTitle = "Pessoas Apenas Registradas";
      Person.findAll({
        where: {state: 'registered'},
      }).then(r => {
        context.person = utils.changeSG(r);
        res.render("list", context);
      });
      break;
    case "form":
      context.pageTitle = "Pessoas em Formação";
      Person.findAll({
        where: {state: "formation"}
      }).then(r => {
        context.person = utils.changeSG(r);
        res.render("list", context);
      });
      break;
    case "inte":
      context.pageTitle = "Pessoas em Estágio";
      Person.findAll({
        where: {state: "internship"}
      }).then(r => {
        context.person = utils.changeSG(r);
        res.render("list", context);
      });
      break;
    case "hire":
      context.pageTitle = "Pessoas Colocadas";
      Person.findAll({
        where: {state: "hired"}
      }).then(r => {
        context.person = utils.changeSG(r);
        res.render("list", context);
      });
      break;
    case "rese":
      context.pageTitle = "Pessoas em Reserva";
      Person.findAll({
        where: {state: "reserved"}
      }).then(r => {
        context.person = utils.changeSG(r);
        res.render("list", context);
      });
      break;
    case 'eval':
      context.pageTitle = "Pessoas Avaliadas";
      Person.findAll({
        where: {
          score: {
            [Sequelize.Op.ne]: null
          }
        },
      }).then(r => {
        context.person = utils.changeSG(r);
        res.render('list_eval', context);
      });
      break;
    default:
      res.redirect("/");
  }
});

app.get("/details/:userId(\\d+)", (req, res) => {
  if (!req.user) return res.redirect('/login');
  let options = {};
  options.user = req.user;
  options.admin = req.user.group === 'admin' ? true : false;

  Person.findById(req.params.userId)
  .then(r => {
    options = Object.assign(options, {
      pageTitle: r.dataValues.name,
      person: utils.changeSG(r),
      birthdate: utils.getProperDate(r.dataValues.birthdate)
    });
    return r.getFormations();
  })
  .then(fs => {
    options.formation = fs;
    return User.find({
      where: {
        id: options.person.userId
      }
    });
  })
  .then(u => {
    options.createdBy = u.dataValues.username;
    return res.render("details", options);
  });
});

app.get("/edit/:userId(\\d+)", (req, res) => {
  if (!req.user) {
    return res.redirect('/login');
  }
  Person.findById(req.params.userId).then(r => {
    res.render("edit", {
      pageTitle: r.dataValues.name,
      person: r,
      birthdate: utils.getProperDate(r.dataValues.birthdate),
      user: req.user,
      admin: req.user.group === 'admin' ? true : false
    });
  });
});

app.post("/edit/:userId(\\d+)", [
    check("name").matches(/^[a-zA-Z0-9_ .]+$/),
    check("birthdate").matches(/^\d{4}-\d{2}-\d{2}$/),
    check("phone").isMobilePhone(),
    check("email").isEmail(),
    check("bi").isNumeric(),
    check("nif").isNumeric(),
    check("gender").isIn(["male", "female"]),
    check("state").isIn([
      "registered",
      "formation",
      "internship",
      "hired",
      "reserved"
    ])
  ],
  (req, res) => {
    if (!req.user) {
      return res.redirect('/login');
    }
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      Person.findById(req.params.userId).then(r => {
        res.render("edit", {
          pageTitle: r.dataValues.name,
          person: r,
          birthdate: utils.getProperDate(r.dataValues.birthdate),
          error: utils.changeError(errors.array()[0])
        });
      });
    } else {
      Person.update(
        {
          name: req.body.name,
          birthdate: req.body.birthdate,
          address: req.body.address,
          phone: req.body.phone,
          email: req.body.email,
          bi: req.body.bi,
          nif: req.body.nif,
          gender: req.body.gender,
          state: req.body.state,
          userId: req.user.id,
        },
        {
          where: {
            id: req.params.userId
          }
        }
      ).then(
        r => {
          res.redirect(`/details/${req.params.userId}`);
        },
        e => {
          res.redirect(`/edit/${req.params.userId}`);
        }
      );
    }
  }
);

app.get("/avaliar/:userId(\\d+)", (req, res) => {
  if (!req.user) {
    return res.redirect('/login');
  }
  Person.findById(req.params.userId).then(r => {
    res.render("avaliar", {
      pageTitle: "Avaliação do Estagiário",
      person: r,
      user: req.user,
      admin: req.user.group === 'admin' ? true : false
    });
  });
});

app.post("/avaliar/:userId(\\d+)", [
    check("shop").isAlpha("pt-PT"),
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
    check("responsible_hr").isAlpha("pt-PT"),
    check("advisor").isAlpha("pt-PT")
  ],
  (req, res) => {
    if (!req.user) {
      return res.redirect('/login');
    }
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      Person.findById(req.params.userId).then(r => {
        res.render(`avaliar`, {
          pageTitle: "Avaliação do Estagiário",
          error: utils.changeError(errors.array()[0]),
          form_data: req.body,
          person: r
        });
      });
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
        userId: req.user.id,
      }).then(ev => {
        // Fazer update do score em Person.score e Person.scoreText
        Evaluation.findAll({where: {personId: req.params.userId}})
        .then(evs => {
          utils.setScore(evs)
          Person.update({
            score: evs.media,
            scoreText: evs.mediaText
          }, {
            where: {
              id: req.params.userId
            }
          }).then(r => {
            return res.redirect(`/avaliado/${req.params.userId}`);
          })
        });
      });
    }
  }
);

app.get("/avaliado/:userId(\\d+)", (req, res) => {
  if (!req.user) {
    return res.redirect('/login');
  }
  let options = null;
  Person.findById(req.params.userId)
    .then(person => {
      options = {
        pageTitle: `Avaliações de ${person.dataValues.name}`,
        person,
        user: req.user,
        admin: req.user.group === 'admin' ? true : false
      };
      return person.getEvaluations();
    })
    .then(e => {
      options.evaluations = utils.setScore(e);
      return res.render("avaliado", options);
    });
});

app.get("/avaliar_edit/:av_id(\\d+)", (req, res) => {
  if (!req.user) {
    return res.redirect('/login');
  }
  let options = { 
    pageTitle: "Avaliação do Estágiario",
    user: req.user,
    admin: req.user.group === 'admin' ? true : false
  };
  Evaluation.findById(req.params.av_id)
    .then(av => {
      options.evaluations = av;
      return Person.findById(av.dataValues.personId);
    })
    .then(person => {
      options.person = person;
      return res.render("avaliar_edit", options);
    });
});

app.post("/avaliar_edit/:av_id(\\d+)", [
    check("shop").isAlpha("pt-PT"),
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
    check("responsible_hr").isAlpha("pt-PT"),
    check("advisor").isAlpha("pt-PT")
  ],
  (req, res) => {
    if (!req.user) {
      return res.redirect('/login');
    }
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      let options = { pageTitle: "Avaliação do Estágiario" };
      Evaluation.findById(req.params.av_id)
        .then(av => {
          options.evaluations = av;
          return Person.find(av.dataValues.personId);
        })
        .then(person => {
          options.person = person;
          options.error = utils.changeError(errors.array()[0]);
          return res.render("avaliar_edit", options);
        });
    } else {
      Evaluation.update(
        {
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
          userId: req.user.id,
        },
        {
          where: {
            id: req.params.av_id
          }
        }
      ).then(() => {
        // Fazer update do score em Person.score e Person.scoreText
        Evaluation.findAll({where: {personId: req.body.personId}})
        .then(evs => {
          utils.setScore(evs);
          Person.update({
            score: evs.media,
            scoreText: evs.mediaText
          }, {
            where: {
              id: req.body.personId
            }
          }).then(r => {
            return res.redirect(`/avaliado/${req.body.personId}`);
          });
        });
      });
    }
  }
);

app.get("/admin", (req, res) => {
  if (!req.user || req.user.group !== 'admin') {
    return res.redirect('/login');
  }
  User.findAll().then(r => {
    return res.render("admin", {
      pageTitle: "Administração",
      person: r,
      user: req.user,
      admin: req.user.group === 'admin' ? true : false
    });
  });
});

app.get("/create_user", (req, res) => {
  if (!req.user && req.user.group !== 'admin') {
    return res.redirect('/login');
  }
  res.render("create_user", {
    pageTitle: "Criar Utilizador",
    user: req.user,
    admin: req.user.group === 'admin' ? true : false
  });
});

app.post("/create_user", [
    check("username").matches(/^[a-zA-Z0-9_.-]+$/),
    check("group").isIn(["admin", "regular"]),
    check("password").isLength({ min: 6 })
  ],
  (req, res) => {
    if (!req.user && req.user.group !== 'admin') {
      return res.redirect('/login');
    }
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.render("create_user", {
        pageTitle: "Criar Utilizador",
        error: utils.changeError(errors.array()[0]),
        form_data: req.body
      });
    }
    if (req.body.password !== req.body.confirm_password) {
      return res.render("create_user", {
        pageTitle: "Criar Utilizador",
        error: {
          param: "Senhas",
          msg: "não são iguais"
        },
        form_data: req.body
      });
    }
    User.findAndCount({
      where: {
        username: req.body.username
      }
    }).then(r => {
      if (r.count > 0) {
        return res.render("create_user", {
          pageTitle: "Criar Utilizador",
          error: {
            param: "Nome de Utilizador",
            msg: "já foi tomado"
          },
          form_data: req.body
        });
      }
      User.create({
        username: req.body.username,
        group: req.body.group,
        password: bcrypt.hashSync(req.body.password)
      }).then(() => {
        return res.redirect("/admin");
      });
    });
  }
);

app.get("/login", (req, res) => {
  if (req.user) {
    return res.redirect("/");
  }
  res.render("login", { pageTitle: "Entrar" });
});

app.post("/login", (req, res, next) => {
  passport.authenticate("local", (err, user, info) => {
    if (info) {
      let options = {};
      options.pageTitle = "Entrar";
      if (info.message) {
        options.error = {
          param: "Credenciais",
          msg: "Invalidos"
        };
      } else {
        options.error = info;
      }
      return res.render("login", options);
    }
    if (err) {
      return next(err);
    }
    if (!user) {
      return res.redirect("/login");
    }
    req.login(user, err => {
      if (err) {
        return next(err);
      }
      return res.redirect('/');
    });
  })(req, res, next);
});

app.get("/logout", function(req, res) {
  req.logout();
  res.redirect("/login");
});

app.get('/delete_user/:userId', (req, res) => {
  if (!req.user) return res.redirect('/login');
  User.destroy({
    where: {
      id: req.params.userId
    }
  })
  .then(() => {
    return res.redirect('/admin');
  });
});

app.get('/delete_person/:userId/:category', (req, res) => {
  if (!req.user || req.user.group !== 'admin') return res.redirect('/login');
  Person.destroy({
    where: {
      id: req.params.userId
    }
  })
  .then(() => {
    return res.redirect(`/pessoas/${req.params.category}`);
  })
});

app.get('/delete_evaluation/:av_id/:userId', (req, res) => {
  if (!req.user || req.user.group !== 'admin') return res.redirect('/login');
  Evaluation.destroy({
    where: {
      id: req.params.av_id
    }
  })
  .then(() => {
    return res.redirect(`/avaliado/${req.params.userId}`);
  });
});

app.get('/formations', (req, res) => {
  if (!req.user || req.user.group !== 'admin') return res.redirect('/login');
  Formation.findAll()
  .then(fs => {
    res.render('formations', {
      pageTitle: 'Formações Disponiveis',
      formations: fs
    });
  });
});

app.get('/add_formation', (req, res) => {
  if (!req.user || req.user.group !== 'admin') return res.redirect('/login');
  res.render('add_formation', {
    pageTitle: 'Registar Formação'
  });
});

app.post('/add_formation', [
  check('name').matches(/.+/),
  check('teoric_part').isNumeric(),
  check('pratic_part').isNumeric(),
  check('subscription_cost').isNumeric(),
  check('certificate_cost').isNumeric(),
],(req, res) => {
  if (!req.user || req.user.group !== 'admin') return res.redirect('/login');
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.render('add_formation', {
      pageTitle: 'Registar Formação',
      error: utils.changeError(errors.array()[0]),
      form_data: req.body
    });
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
      return res.redirect('/formations');
    });
  }
});

app.get('/formation/:fid(\\d+)', (req, res) => {
  if (!req.user || req.user.group !== 'admin') return res.redirect('/login');
  Formation.findById(req.params.fid)
  .then(f => {
    return res.render('formation_edit', {
      pageTitle: 'Editar Formação',
      formation: f.dataValues
    });
  });
});

app.post('/formation/:fid(\\d+)', [
  check('name').matches(/.+/),
  check('teoric_part').isNumeric(),
  check('pratic_part').isNumeric(),
  check('subscription_cost').isNumeric(),
  check('certificate_cost').isNumeric(),
], (req, res) => {
  if (!req.user || req.user.group !== 'admin') return res.redirect('/login');
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.render('formation_edit', {
      pageTitle: 'Editar Formação',
      formation: f.dataValues,
      error: utils.changeError(errors.array()[0])
    })
  } else {
    Formation.update({
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
    }).then(r => {
      return res.redirect('/formations');
    });
  }
});

app.get('/choose_formation/:personId', (req, res) => {
  if (!req.user) return res.redirect('/login');
  let context = {};
  Formation.findAll()
  .then(fs => {
    context.formation = fs;
    return Person.findById(req.params.personId)
  })
  .then(p => {
    context.pageTitle = `Escolhe Formações para ${p.name}`;
    context.personId = p.id;
    return p.getFormations();
  })
  .then(fs => {
    context.formation = context.formation.filter(el => {
      for (element of fs) {
        if (element.id === el.id){
          return false
        }
      }
      return true;
    });
    res.render('choose_formation', context);
  });
});

app.post('/choose_formation/:personId', (req, res) => {
  if (!req.user) return res.redirect('/login');

  let context = {};
  Person.findById(req.params.personId)
  .then(p => {
    context.p = p;
    return Formation.findAll();
  })
  .then(fs => {
    formations = [];
    for (formation of fs) {
      if (req.body[formation.id] === 'on') {
        formations.push(formation.id);
      }
    }
    return context.p.addFormations(formations);
  })
  .then(() => {
    context.p.state = 'formation';
    return context.p.save();
  })
  .then(() => {
    res.redirect(`/details/${req.params.personId}`);
  });
});


app.listen(port, "0.0.0.0", () => {
  console.log("Server started at port %d", port);
});
