const express = require('express')
    , session = require('express-session')
    , uuid = require('uuid/v4')
    , MySQLStore = require('express-mysql-session')(session)
    , passport = require('passport')
    , LocalStrategy = require('passport-local')
    , bcrypt = require('bcrypt-nodejs');

const {User} = require('../models/User');

passport.use(new LocalStrategy((username, password, done) => {
    User.find({
        where: {
            username,
        }
    })
    .then(res => {
        if (!res) {
            return done(null, false, {msg: 'Invalid Credentials'});
        }
        if (!bcrypt.compareSync(password, res.dataValues.password)) {
            return done(null, false, {msg: 'Invalid Credentials'});
        }
        return done(null, res.dataValues);
    });
}));

passport.serializeUser((user, done) => {
    return done(null, user.id);
});

passport.deserializeUser((id, done) => {
    User.findById(id)
    .then(res => {
        if (!res) {
            return done(null, false);
        }
        return done(null, res.dataValues);
    });
});

const app = express();

app.use((req, res, next) => {
    console.log(`${new Date().toLocaleString()} ${req.method} ${req.url}`);
    next();
})
app.use(express.json());
app.use(session({
    secret: 'this is a secret key',
    resave: false,
    saveUninitialized: true,
    genid: () => uuid(),
    store: new MySQLStore({
        host: 'localhost',
        port: 3306,
        database: 'rh-db',
        user: 'root',
        password: ''
    }),
}));
app.use(passport.initialize());
app.use(passport.session());

app.get('/', (req, res) => {
    res.send('This is the homepage');
});

app.get('/login', (req, res) => {
    res.send('This is the Login Page');
});

app.post('/login', passport.authenticate('local', {
    successRedirect: '/', failureRedirect: '/login'
}));

app.get('/logout', (req, res) => {
    req.logout();
    res.redirect('/login');
});

app.listen(3000, () => {
    console.log('Server started on port 3000');
});