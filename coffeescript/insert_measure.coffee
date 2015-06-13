module.exports = (db,sensor,location,value,callback=->) ->
    
    measure =
        timestamp : new Date()
        location_id : location._id
        beehouse_id : sensor.beehouse_id
        type : 'measure'
        name : sensor.name
        raw_value : value
        value : (value-sensor.bias)*sensor.gain
        unit : sensor.unit

    db.save measure,callback