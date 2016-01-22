
expect = require 'must'

fixtures = require './fixtures'

takeMeasure = require '../takeMeasure'

describe "taking measure with a roman scale",->

    it "should work", ->

        device = require '../devices/' + fixtures.stand.device
        device.analogWrite 'in_voltage0_raw',195
        device.analogWrite 'in_voltage1_raw',205
        sensor = fixtures.stand.sensors[0]
        sensor.device = device
        
        result = takeMeasure(sensor)
        expect(result).to.not.be.null()
        result.raw_value.must.be.number()
