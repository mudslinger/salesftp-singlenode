AWS = require 'aws-sdk'
metadata = new AWS.MetadataService
metadata.request '/latest/meta-data/public-ipv4',(err,ipv4)->
  require('./ftp-service')("1234",ipv4) unless err

