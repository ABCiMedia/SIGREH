const winston = require('winston')
const FileTansport = require('winston-daily-rotate-file')

const myFormat = winston.format.printf(info => `${info.timestamp} [${info.label}] ${info.level}: ${info.message}`)

const logger = winston.createLogger({
    format: winston.format.combine(
        winston.format.label({label: 'SIGREH'}),
        winston.format.timestamp({
            format: 'YYYY-MM-DD HH:mm:ss'
        }),
        myFormat
    ),
    transports: [
        new FileTansport({
            dirname: 'logs',
            filename: 'sigreh-%DATE%.log',
            datePattern: 'YYYY-MM-DD-HH',
            zippedArchive: true,
            maxSize: '20m',
            maxFiles: '14d'
        }),
        new winston.transports.Console()
    ]
})

module.exports = {
    logger
}