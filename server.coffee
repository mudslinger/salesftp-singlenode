pm2 = require 'pm2'
cluster = require 'cluster'
# metadata.request '/latest/meta-data/public-ipv4',(err,ipv4)->
#   require('./ftp-service')("1234",ipv4) unless err

pm2.connect (err)->
  pm2.start
    script : 'start-ftp-server.coffee'
    name: 'ftpserver'
    instances : 3 
    exec_mode : 'cluster'
    (err,dt)->
      console.log err,dt
      