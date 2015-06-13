module.exports = (db,location,apiary_id,name,data,callback=->) ->
        
    measure =
        timestamp : new Date()
        location_id : location._id
        apiary_id : apiary_id
        type : 'measure'
        name : name
        data : data

    db.save measure,callback