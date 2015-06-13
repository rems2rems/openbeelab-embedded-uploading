http = require 'http'
moment = require 'moment'
dbDriver = require '../../dbUtil/javascript/dbUtil'
dbConfig = require './config'
db = dbDriver.database(dbConfig)


year = 2014
month = 4
day = 7

for month in [4..10]

    do (month)->

        for day in [1..31]

            do (day)->

                #wunderground csv url for weather of bordeaux airport day by day (hour results in data)
                #data:
                #TimeCEST,TemperatureC,Dew PointC,Humidity,Sea Level PressurehPa,VisibilityKm,Wind Direction,Wind SpeedKm/h,Gust SpeedKm/h,Precipitationmm,Events,Conditions,WindDirDegrees,DateUTC
                #12:00 AM,16,13,82,1018,,ESE,9.3,,,,Clear,110,2014-04-06 22:00:00
                csvUrl = "http://www.wunderground.com/history/airport/LFBD/" + year + "/" + month + "/" + day + "/DailyHistory.html?format=1"

                http.get csvUrl,(response)->

                    str = ''

                    #another chunk of data has been recieved, so append it to `str`
                    response.on 'data', (chunk)->
                        str += chunk

                    #the whole response has been recieved, so we just print it out here
                    response.on 'end', ->
                        

                        # console.log str
                        # console.log "csv data:"
                        #console.log str

                        hoursDatas = str.split("<br />")
                        #hoursData.shift()
                        # console.log hoursDatas[0]
                        # console.log hoursDatas[1]

                        for hoursData in hoursDatas[1..]

                            data = hoursData.split(",")

                            if data[data.length - 1] is null or data[data.length - 1] is undefined or data[data.length - 1].trim() is ""
                                # console.log "no date!"
                                # console.log day
                                # console.log data[data.length - 1]
                                continue

                            
                            timestamp = moment(data[data.length - 1])
                            if timestamp.date() != day
                                # console.log "no match!"
                                # console.log day
                                # console.log data[data.length - 1]
                                #console.log timestamp.format()
                                continue

                            time = moment("" + year + "-" + month + "-" + day + "-" + data[0], "YYYY-MM-DD-hh:mm a");
                            # console.log "time:" + time.format()
                            # console.log "temp:" + data[1]

                            windData = 
                                speed : data[7]
                                deg : data[6]

                            weatherData = {}
                            weatherData['temp'] = data[1]
                            weatherData['pressure'] = data[4] #4
                            weatherData['humidity'] = data[3] #3
                            weatherData['wind']  = windData #6 dir #7 speed

                            measure =
                                timestamp : time.format()
                                location_id : "9cc286580ddb2caba76f10ff4b01bdec"
                                apiary_id : "9cc286580ddb2caba76f10ff4b01ca7e"
                                type : 'measure'
                                name : 'weather'
                                data : weatherData
                                source : "wunderground.com"
                                comments : "inserted by custom script on 2014-nov-26"

                            #console.log measure
                            db.save measure
                           

                            #callback('weather',ret)