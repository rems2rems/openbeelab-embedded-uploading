expect = require 'must'

fixtures = require './fixtures'

saveMeasure = require '../saveMeasure'

config = require '../config'
dbDriver = require '../../../openbeelab-db-util/javascript/mockDriver'
dbServer = dbDriver.connectToServer(config.database)
dataDb = dbServer.useDb(config.name + "_data")

describe "saving measure",->

    it "should work", (done)->

        device = require '../devices/' + fixtures.stand.device
        sensor = fixtures.stand.sensors[0]
        sensor.device = device
        
        measure =
            type : 'measure'
            value : 321.54
            name : 'global-weight'

        saveMeasure(measure,fixtures.stand,dataDb)
        done()
