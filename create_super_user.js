#!/usr/bin/env node

const {User} = require('./models/User');
const bcrypt = require('bcrypt-nodejs');
const argv = require('yargs')
                .usage('Usage: node $0 -u <username> -p <password>')
                .option('username', {
                    alias: 'u',
                    demand: true,
                    requiresArg: true
                })
                .option('password', {
                    alias: 'p',
                    demand: true,
                    requiresArg: true
                }).argv;

User.create({
    username: argv.username,
    password: bcrypt.hashSync(argv.password),
    group: 'admin'
})
.then(() => {
    console.log('[+] User created successfully!!!');
    process.exit(0);
});