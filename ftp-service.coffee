ftpd = require 'ftpd'
moment = require 'moment'
AWS = require 'aws-sdk'
AWS.config.region = 'ap-northeast-1'

module.exports = (config = {passwd:'1234',port: 21,datastart: 50000,dataend:50999})->

  #console.log passiveIp
  s3 = new AWS.S3
    params:
      s3_endpoint: 's3-ap-northeast-1.amazonaws.com' 
      Bucket: 'sales.wb.yamaokaya.com'
  S3fs = require './s3fs'

  fss = {}
  getUserFS = (key)->
    fss[key] = new S3fs(key,s3) unless fss[key]
    #console.log key,fss[key]
    return fss[key]

  options =
    pasvPortRangeStart: config.datastart
    pasvPortRangeEnd: config.dataend
    useWriteFile: true
    useReadFile: true
    getInitialCwd: (connection)->
      ''
    getRoot: (user)->
      ''

  server = new ftpd.FtpServer config.passiveIp, options
  server.on 'client:connected',(conn)->
    username = null
    #console.log "Client connected from #{conn.socket.remoteAddress}"
    conn.on 'command:user',(user,success,failure)->
      username = user
      if /^s[0-9]{4}$/.test username then success() else failure()
    conn.on 'command:pass' ,(pass,success,failure)->
      if pass == config.passwd
        key = "#{username.match(/[0-9]{4}/)}/#{moment().add(-12,'h').year()}"
        s3.putObject
          Key: key + '/'
          Body: null
          (err,data)->
            unless err
              success(username,getUserFS(key))
            else
              failure()
      else
        failure()

  server.debugging = 4
  server.listen config.port
  console.log "FTPD listening on port #{config.port}"


