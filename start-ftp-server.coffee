AWS = require 'aws-sdk'
metadata = new AWS.MetadataService
ctlport = 20021
rstart = 50001
rend = rstart + 1999
metadata.request '/latest/meta-data/public-ipv4',(err,ipv4)->
  require('./ftp-service')(
    passiveIp: ipv4
    port: ctlport
    datastart: rstart
    dataend: rend
    passwd: 'smt35nje'
  )
