sh = require('execSync')

exports.read = (pin)->
    command = 'python /home/ubuntu/openbeelab/uploader/javascript/readadc.py ' + pin
    result = sh.exec(command)
    value = parseInt(result.stdout)
    return value
