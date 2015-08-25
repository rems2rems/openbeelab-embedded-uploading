// Generated by CoffeeScript 1.9.2
(function() {
  var PidController, Pin, Promise, StepMotor, _searchEquilibrium, sleep;

  Promise = require('promise');

  PidController = require('node-pid-controller');

  require('../../openbeelab-util/javascript/numberUtils').install();

  Pin = require('./pin');

  StepMotor = require('./stepMotor');

  sleep = require('../../openbeelab-util/javascript/timeUtils').sleep;

  _searchEquilibrium = function(motor, photoDiode1, photoDiode2, pid) {
    var command, deltaLight, goalIsReached;
    console.log("searching equilibrium...");
    deltaLight = photoDiode1.getValue() - photoDiode2.getValue();
    command = pid.update(deltaLight).floor();
    motor.move(command);
    goalIsReached = command < 5;
    if (goalIsReached) {
      return command;
    }
    return command + _searchEquilibrium(motor, photoDiode1, photoDiode2, pid);
  };

  module.exports = function(sensor, device) {
    var motor, nbSteps, photoDiode1, photoDiode2, pid;
    motor = StepMotor(device, sensor.motor);
    photoDiode1 = Pin.buildAdc(device, sensor.photoDiode1);
    photoDiode2 = Pin.buildAdc(device, sensor.photoDiode2);
    pid = new PidController(0.25, 0.01, 0.01, 1);
    pid.setTarget(sensor.deltaTarget);
    nbSteps = 0;
    return {
      searchEquilibrium: function() {
        return _searchEquilibrium(motor, photoDiode1, photoDiode2, pid);
      }
    };
  };

}).call(this);
