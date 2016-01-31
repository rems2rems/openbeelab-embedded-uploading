// Generated by CoffeeScript 1.9.2
(function() {
  var config, db, dbDriver;

  dbDriver = require('../../../openbeelab-db-util/javascript/dbDriver');

  config = require('../config');

  config.name = config.name + "_config";

  db = dbDriver.connectToServer(dbConfig.database).useDb(config.database.name + "_config");

  db.get(config.stand_id).then(function(stand) {
    var device;
    device = require('./devices/' + stand.device);
    if (stand.sleepMode === true && device.planWakeup && device.shutdown) {
      device.planWakeup(stand.sleepDuration);
      console.log("system will reboot " + stand.sleepDuration + " seconds after shutdown");
      device.shutdown();
      return console.log("system is going to shutdown...");
    }
  })["catch"](function(err) {
    var device;
    console.log(err);
    device = require('./devices/arietta_g25');
    device.planWakeup(3300);
    console.log("system will reboot 3300 seconds after shutdown");
    device.shutdown();
    return console.log("system is going to shutdown...");
  });

}).call(this);