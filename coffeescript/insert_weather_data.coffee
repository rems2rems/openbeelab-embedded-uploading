# Copyright 2012-2014 OpenBeeLab.
# This file is part of the OpenBeeLab project.

# The OpenBeeLab project is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# The OpenBeeLab project is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with OpenBeeLab.  If not, see <http://www.gnu.org/licenses/>.

dbDriver = require '../../dbUtil/javascript/dbUtil'
dbConfig = require './config'
db = dbDriver.database(dbConfig)
acquire_sensor_data = require './acquire_sensor_data'
insert_measure = require './insert_measure'
insert_external_measure = require './insert_external_measure'

Promise = require 'promise'

dbGet = Promise.denodeify db.get.bind(db)

apiary = null
apiaryLocation = null

apiariesUrl = '_design/apiaries/_view/by_name?key="'+ dbConfig.apiary_name+'"'
apiariesPromise = dbGet apiariesUrl
apiariesPromise.then (apiaries) ->

    apiary = apiaries[0].value
    return dbGet apiary.location_id

.then (location) ->

    apiaryLocation = location

    for external_site in dbConfig.external_sites

        getExternalData = require('./'+external_site)

        getExternalData location,(name,data)->

            insert_external_measure db,location,apiary._id,name,data, ->

                console.log "external measure ("+external_site+") uploaded to db " + dbConfig.db