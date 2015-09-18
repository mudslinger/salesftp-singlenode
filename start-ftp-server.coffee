AWS = require 'aws-sdk'
metadata = new AWS.MetadataService
ctlport = 20021 + parseInt(process.env.NODE_APP_INSTANCE || 0)*1000
rstart = 50000 + parseInt(process.env.NODE_APP_INSTANCE || 0) * 1000
rend = rstart + 999
metadata.request '/latest/meta-data/public-ipv4',(err,ipv4)->
  require('./ftp-service')(
    passwd: '1234'
    passiveIp: ipv4
    port: ctlport
    datastart: rstart
    dataend: rend
  )
