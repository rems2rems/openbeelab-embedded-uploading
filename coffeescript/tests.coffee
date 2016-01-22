
must = require 'must'
couchdb = require('mock-couch').createServer()
createBundle = require '../../openbeelab-db-admin/javascript/create_bundle'
fixtures = require './testFixtures'

couchdb.listen(5985)
couchdb.addDB('test_db_config')
couchdb.addDB('test_db_data')

database =

    name : 'test_db'
    host : 'localhost'
    protocol : 'http'
    port : 5985


