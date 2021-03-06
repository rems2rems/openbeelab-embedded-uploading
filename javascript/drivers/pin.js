// Generated by CoffeeScript 1.9.2
(function() {
  module.exports = {
    buildGpio: function(device, pinName, direction) {
      if (direction == null) {
        direction = "in";
      }
      device["export"](pinName);
      device.setDirection(pinName, direction);
      return {
        setInputMode: (function(_this) {
          return function() {
            return device.setInputMode(pinName);
          };
        })(this),
        setOutputMode: (function(_this) {
          return function() {
            return device.setOutputMode(pinName);
          };
        })(this),
        isOn: function() {
          return this.getValue() === true;
        },
        isOff: function() {
          return this.getValue() === false;
        },
        getValue: function() {
          return device.digitalRead(pinName);
        },
        setValue: function(value) {
          return device.digitalWrite(pinName, value);
        },
        setOn: function() {
          return this.setValue(true);
        },
        setOff: function() {
          return this.setValue(false);
        },
        unexport: function() {
          return device.unexport(pinName);
        }
      };
    },
    buildAdc: function(device, pinName) {
      return {
        getValue: function() {
          return device.analogRead(pinName);
        }
      };
    }
  };

}).call(this);
