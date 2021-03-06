// Generated by CoffeeScript 1.9.2
(function() {
  var config, configDb, dataDb, dbDriver, saveMeasure, takeMeasure;

  config = require('./config');

  takeMeasure = require('./takeMeasure');

  saveMeasure = require('./saveMeasure');

  dbDriver = require('../../openbeelab-db-util/javascript/dbDriver');

  configDb = dbDriver.connectToServer(dbConfig.database).useDb(config.database.name + "_config");

  dataDb = dbDriver.connectToServer(dbConfig.database).useDb(config.database.name + "_data");

  configDb.get(config.stand_id).then(function(stand) {
    var device, i, len, measure, ref, results, sensor;
    device = require('./devices/' + stand.device);
    ref = stand.sensors;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      sensor = ref[i];
      if (!sensor.active) {
        continue;
      }
      sensor.device = device;
      measure = takeMeasure(sensor);
      measure.location_id = stand.location._id;
      if (stand.beehouse._id != null) {
        measure.beehouse_id = stand.beehouse._id;
      }
      measure.stand_id = stand._id;
      results.push(saveMeasure(measure, dataDb));
    }
    return results;
  })["catch"](function(err) {
    return console.log(err);
  });

}).call(this);
