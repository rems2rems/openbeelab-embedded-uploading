#!/usr/bin/python

import sys
import time
from python_adc import analog_read
pin = int(sys.argv[1])
adc_value = analog_read(pin)
sys.stdout.write(str(adc_value))
