// Generated by CoffeeScript 1.9.2
(function() {
  var Pin, __version__, _export, direction, getVersion, get_gpio_path, get_kernel_id, get_value, legacy_id, pin2kid, pinlevel, pinmode, pwmIds, set_edge, set_value, soft_pwm_export, soft_pwm_period, soft_pwm_pulse, soft_pwm_steps, unexport;

  __version__ = 'v1.0.0';

  require('thread');

  require('select');

  require('math');

  if (process.platform.contains("Linux-2")) {
    legacy_id = true;
  } else {
    legacy_id = false;
  }

  pin2kid = {
    'J4.7': 55,
    'J4.8': 54,
    'J4.10': 53,
    'J4.11': 56,
    'J4.12': 63,
    'J4.13': 57,
    'J4.14': 62,
    'J4.15': 58,
    'J4.17': 59,
    'J4.19': 60,
    'J4.21': 61,
    'J4.23': 32,
    'J4.24': 33,
    'J4.25': 40,
    'J4.26': 39,
    'J4.27': 38,
    'J4.28': 37,
    'J4.29': 124,
    'J4.30': 123,
    'J4.31': 100,
    'J4.32': 127,
    'J4.33': 99,
    'J4.34': 75,
    'J4.35': 98,
    'J4.36': 76,
    'J4.37': 97,
    'J4.38': 77,
    'J4.39': 96,
    'J4.40': 78
  };

  pinmode = {
    "OUTPUT": "out",
    "INPUT": "in",
    "PWM": "out"
  };

  pinlevel = {
    "HIGH": 1,
    "LOW": 0
  };

  pwmIds = {
    "J4.34": 0,
    "J4.36": 1,
    "J4.38": 2,
    "J4.40": 3
  };

  getVersion = function() {
    return __version__;
  };

  get_gpio_path = function(kernel_id) {
    var iopath;
    kernel_id = kernel_id - 32;
    if (legacy_id === true) {
      iopath = "/sys/class/gpio/gpio" + (kernel_id + 32);
    } else {
      iopath = "/sys/class/gpio/pio";
      if (kernel_id >= 0 && kernel_id <= 31) {
        iopath = iopath + "A" + (kernel_id - 0);
      }
      if (kernel_id >= 32 && kernel_id <= 63) {
        iopath = iopath + "B" + (kernel_id - 32);
      }
      if (kernel_id >= 64 && kernel_id <= 95) {
        iopath = iopath + "C" + (kernel_id - 64);
      }
      if (kernel_id >= 96 && kernel_id <= 127) {
        iopath = iopath + "D" + (kernel_id - 96);
      }
      if (kernel_id >= 128 && kernel_id <= 159) {
        iopath = iopath + "E" + (kernel_id - 128);
      }
    }
    return iopath;
  };

  get_kernel_id = function(connector_name, pin_number) {
    return pinname2kernelid(connector_name + "." + pin_number);
  };

  _export = function(kernel_id) {
    var f, iopath;
    iopath = get_gpio_path(kernel_id);
    if (!fs.existsSync(iopath)) {
      f = open('/sys/class/gpio/export', 'w');
      if (legacy_id === true) {
        f.write(str(kernel_id));
      } else {
        f.write(str(kernel_id - 32));
      }
      return f.close();
    }
  };

  unexport = function(kernel_id) {
    var f, iopath;
    iopath = get_gpio_path(kernel_id);
    if (fs.existsSync(iopath)) {
      f = open('/sys/class/gpio/unexport', 'w');
      if (legacy_id === true) {
        f.write(str(kernel_id));
      } else {
        f.write(str(kernel_id - 32));
      }
      return f.close();
    }
  };

  direction = function(kernel_id, direct) {
    var f, iopath;
    iopath = get_gpio_path(kernel_id);
    if (fs.existsSync(iopath)) {
      f = open(iopath + '/direction', 'w');
      f.write(direct);
      return f.close();
    }
  };

  set_value = function(kernel_id, value) {
    var f, iopath;
    iopath = get_gpio_path(kernel_id);
    if (fs.existsSync(iopath)) {
      f = open(iopath + '/value', 'w');
      f.write(str(value));
      return f.close();
    }
  };

  get_value = function(kernel_id) {
    var a, f, iopath;
    if (kernel_id !== -1) {
      iopath = get_gpio_path(kernel_id);
      if (fs.existsSync(iopath)) {
        f = open(iopath + '/value', 'r');
        a = f.read();
        f.close();
        return parseInt(a, 10);
      }
    }
  };

  set_edge = function(kernel_id, value) {
    var f, iopath;
    iopath = get_gpio_path(kernel_id);
    if (fs.existsSync(iopath)) {
      if (value === 'none' || value === 'rising' || value === 'falling' || value === 'both') {
        f = open(iopath + '/edge', 'w');
        f.write(value);
        return f.close();
      }
    }
  };

  soft_pwm_export = function(kernel_id) {
    var f, iopath;
    iopath = '/sys/class/soft_pwm/pwm' + str(kernel_id);
    if (!fs.existsSync(iopath)) {
      f = open('/sys/class/soft_pwm/export', 'w');
      f.write(str(kernel_id));
      return f.close();
    }
  };

  soft_pwm_period = function(kernel_id, value) {
    var f, iopath;
    iopath = '/sys/class/soft_pwm/pwm' + str(kernel_id);
    if (fs.existsSync(iopath)) {
      f = open(iopath + '/period', 'w');
      f.write(str(value));
      return f.close();
    }
  };

  soft_pwm_pulse = function(kernel_id, value) {
    var f, iopath;
    iopath = '/sys/class/soft_pwm/pwm' + str(kernel_id);
    if (fs.existsSync(iopath)) {
      f = open(iopath + '/pulse', 'w');
      f.write(str(value));
      return f.close();
    }
  };

  soft_pwm_steps = function(kernel_id, value) {
    var f, iopath;
    iopath = '/sys/class/soft_pwm/pwm' + str(kernel_id);
    if (fs.existsSync(iopath)) {
      f = open(iopath + '/pulses', 'w');
      f.write(str(value));
      return f.close();
    }
  };

  Pin = (function() {
    "FOX and AriaG25 pins related class";
    var constructor, digitalRead, digitalWrite, fd, high, kernel_id, low, wait_edge;

    function Pin() {}

    kernel_id = null;

    fd = null;

    constructor = function(pin, mode) {
      var iopath;
      this.kernel_id = pin2kid[pin];
      direction(this.kernel_id, pinmode[mode]);
      if (mode === "INPUT" || mode === "OUTPUT") {
        _export(this.kernel_id);
        iopath = get_gpio_path(this.kernel_id);
        if (fs.existsSync(iopath)) {
          return this.fd = open(iopath + '/value', 'r');
        }
      } else {
        return soft_pwm_export(this.kernel_id);
      }
    };

    high = function() {
      return set_value(this.kernel_id, 1);
    };

    low = function() {
      return set_value(this.kernel_id, 0);
    };

    digitalWrite = function(level) {
      return set_value(this.kernel_id, pinlevel[level]);
    };

    digitalRead = function() {
      return get_value(this.kernel_id);
    };

    wait_edge = function(fd, callback, debouncingtime) {
      var counter, events, po, results, timestamp, timestampprec;
      debouncingtime = debouncingtime / 1000.0;
      timestampprec = Math.floor(Date.now() / 1000);
      counter = 0;
      po = select.epoll();
      po.register(fd, select.EPOLLET);
      results = [];
      while (true) {
        events = po.poll();
        timestamp = Math.floor(Date.now() / 1000);
        if ((timestamp - timestampprec > debouncingtime) && counter > 0) {
          callback();
        }
        counter = counter + 1;
        results.push(timestampprec = timestamp);
      }
      return results;
    };

    set_edge = function(value, callback, debouncingtime) {
      if (debouncingtime == null) {
        debouncingtime = 0;
      }
      if (this.fd !== null) {
        set_edge(this.kernel_id, value);
        thread.start_new_thread(this.wait_edge, [this.fd, callback, debouncingtime]);
      } else {
        return thread.exit();
      }
    };

    return Pin;

  })();

}).call(this);
