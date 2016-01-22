module.exports =
   
    location :
        _id : "location:jbc"
        type : "location"
        name : "jbc"
        locationType : "GPS"
        latitude : 43.301854
        longitude : -0.399957
        create_noised_area : true
        noise : 0.0166666667 #degree = 1 minute

    beehouse_model :
        _id : "beehousemodel:dadant"
        name : "dadant"
        type : "beehousemodel"
        weight :
            value : 37
            unit : "Kg"
        extra_box_weight :
            value : 5
            unit : "Kg"

    beehouse :
        _id : 'beehouse:ruche_001'
        type : "beehouse"
        name : 'ruche 001'
        model_id : "beehousemodel:dadant"
        location_id : "location:jbc"
        number_of_extra_boxes : 0
        has_roof : true

    stand :
        _id : "stand:socle_001"
        name : "socle 001"
        type : "stand"
        device : "mock_device_sync"
        sensors : [
            active : true
            name : "global-weight"
            process : "romanScale"
            action : 'searchEquilibrium'
            motor :
                enable : 'J4.8'
                ms1 : 'J4.10'
                ms2 : 'J4.12'
                ms3 : 'J4.14'
                pulse : 'J4.28'
                direction : 'J4.30'
                sleep : 'J4.26'
                reset : 'J4.24'
                stepDelay : 0

            photoDiode1 : 'in_voltage0_raw'
            photoDiode2 : 'in_voltage1_raw'
        ]
        sleepMode : true
        sleepDuration : 3300
        beehouse_id : "beehouse:ruche_001"
        location_id : "location:jbc"