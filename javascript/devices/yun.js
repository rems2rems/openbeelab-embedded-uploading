// Generated by CoffeeScript 1.9.2
(function() {
  var Promise, http;

  http = require('http');

  Promise = require('promise');

  require('../../util/javascript/stringUtils');

  module.exports.read = function(pinUrl) {
    return new Promise(function(fulfill, reject) {
      var options;
      options = {
        host: '192.168.1.38',
        port: 80,
        path: '/arduino/' + pinUrl,
        headers: {
          'Authorization': 'Basic ' + new Buffer('root:arduino').toString('base64')
        }
      };
      return http.get(options, function(response) {
        return response.on('data', function(data) {
          var value;
          value = ("" + data).split('analog')[1].trim().toInt();
          return fulfill(value);
        });
      }).on('error', function(err) {
        console.log("err!!!");
        console.log(err);
        return reject(err);
      });
    });
  };

}).call(this);
