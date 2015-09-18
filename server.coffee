AWS = require 'aws-sdk'
metadata = new AWS.MetadataService
harmony = require 'node-harmony'
# metadata.request '/latest/meta-data/public-ipv4',(err,ipv4)->
#   require('./ftp-service')("1234",ipv4) unless err

metadata.request '/latest/meta-data/public-ipv4',(err,ipv4)->
  server = new harmony.server
  	persistent: false,
  	unavailable: (e,c)->
  		c.write "unavailable"
  client = new harmony.client
    balance: 1000
    listenport: 21001
    ack: 10*1000
  sv1 = require('./ftp-service')("1234",ipv4,20021,50001,50080) unless err