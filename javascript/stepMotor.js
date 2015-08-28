// Generated by CoffeeScript 1.9.2
(function() {
  var Pin, sleep;

  require('../../openbeelab-util/javascript/arrayUtils').install();

  require('../../openbeelab-util/javascript/numberUtils').install();

  sleep = require('../../openbeelab-util/javascript/timeUtils').sleep;

  Pin = require('./pin');

  module.exports = function(device, pins) {
    var direction, enable, ms1, ms2, ms3, pulse, reset, sleepPin;
    enable = Pin.buildGpio(device, pins.enable, 'out');
    ms1 = Pin.buildGpio(device, pins.ms1, 'out');
    ms2 = Pin.buildGpio(device, pins.ms2, 'out');
    ms3 = Pin.buildGpio(device, pins.ms3, 'out');
    pulse = Pin.buildGpio(device, pins.pulse, 'out');
    direction = Pin.buildGpio(device, pins.direction, 'out');
    sleepPin = Pin.buildGpio(device, pins.sleep, 'out');
    reset = Pin.buildGpio(device, pins.reset, 'out');
    ms1.setOff();
    ms2.setOff();
    ms3.setOff();
    return {
      switchOn: function() {
        enable.setOff();
        reset.setOn();
        sleepPin.setOn();
        return sleep(1);
      },
      switchOff: function() {
        enable.setOn();
        reset.setOff();
        return sleepPin.setOff();
      },
      forward: function(nbSteps) {
        if (nbSteps == null) {
          nbSteps = 1;
        }
        return this.move(nbSteps);
      },
      backward: function(nbSteps) {
        if (nbSteps == null) {
          nbSteps = 1;
        }
        return this.move(-1 * nbSteps);
      },
      move: function(nbSteps) {
        var goForward;
        if (nbSteps == null) {
          nbSteps = 1;
        }
        console.log("moving...");
        goForward = nbSteps > 0;
        nbSteps = nbSteps.abs();
        direction.setValue(goForward);
        nbSteps.times(function() {
          pulse.setOn();
          sleep(2);
          pulse.setOff();
          return sleep(2);
        });
      }
    };
  };

}).call(this);
