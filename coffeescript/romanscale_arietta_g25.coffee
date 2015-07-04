Promise = require('promise')

exports.read = ->
	return new Promise( (fulfill, reject)->

        fulfill(Math.floor(Math.random()*4000))
    )