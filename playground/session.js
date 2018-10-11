const session = require('express-session')
    , express = require('express')
    , uuid = require('uuid/v4')
    , MySQLStore = require('express-mysql-session')(session)
    , passport = require('passport')
    , LocalStrategy = require('passport-local')
    , bcrypt = require('bcrypt-nodejs');

const cred = require('../models/credentials')
    , {User} =  require('../models/User');

const app = express();

passport.use(new LocalStrategy((username, password, done) => {
    User.find({where: {username}})
    .then(user => {
        if(!user) {
            return done(null, false, {message: 'Invalid credentials.\n'});
        }
        if (!bcrypt.compareSync(password, user.dataValues.password)) {
            return done(null, false, {message: 'Invalid credentials.\n'});
        }
        return done(null, user.dataValues);
    })
    .catch(error => done(error));
}));

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

app.use(express.urlencoded());
app.use(express.json());
app.use(session({
    secret: 'Ssh, this is a secret key!',
    genid: req =>  uuid(),
    store: new MySQLStore({
        host: cred.host,
        port: 3306,
        database: cred.database,
        user: cred.username,
        password: cred.password
    }),
    saveUninitialized: true,
    resave: false,
}));
app.use(passport.initialize());
app.use(passport.session());

app.get('/', (req, res) => {
    res.send('You got homepage');
});

app.get('/login', (req, res) => {
    res.send(`You got the login page!\n`)
});

app.post('/login', (req, res, next) => {
    passport.authenticate('local', (err, user, info) => {
        if (info) { return res.send(info.message); }
        if (err) { return next(err); }
        if (!user) { return res.redirect('/login'); }
        req.login(user, (err) => {
            if (err) { return next(err); }
            return res.redirect('/authrequired');
        });
    })(req, res, next);
});

app.get('/authrequired', (req, res) => {
    if (req.isAuthenticated()) {
        res.send('you hit the authentication endpoint.\n')
    } else {
        res.redirect('/');
    }
});

app.listen(3000, () => {
    console.log('Server listening on port 3000');
});