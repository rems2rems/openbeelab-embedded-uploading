http = require 'http'
Promise = require('promise')
require '../../util/javascript/stringUtils'

module.exports.read = (pinUrl)-> 
    
    return new Promise( (fulfill, reject)->

        options =
            host: '192.168.1.38'
            port: 80
            path: '/arduino/'+pinUrl
            headers:
                'Authorization': 'Basic ' + new Buffer('root:arduino').toString('base64')

        http.get(options,(response)->
            response.on 'data', (data)->
                
                value = (""+data).split('analog')[1].trim().toInt()
                fulfill(value)
        )
        .on 'error',(err)->
            console.log "err!!!"
            console.log err
            reject(err)
    )