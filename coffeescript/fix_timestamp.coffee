require 'yamljs'
dbDriver = require '../../db/javascript/dbUtil'
dbConfig = require '../../config.yaml'
db = dbDriver.database(dbConfig)

db.get '_design/measures/_view/incorrect?', (err,measures)=>

    #console.log measures[0].value
    #ms = measures.map((m)->m.value)
    #console.log ms[0]
    for measure in measures

        measure = measure.value
        #console.log measure
        #if measure.value?
         #   console.log measure.value + " " + measure.unit

        measure.incorrect_timestamp = measure.timestamp
        measure.timestamp = new Date()
        measure.fixed = true

        db.save measure
    
 