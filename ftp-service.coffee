ftpd = require 'ftpd'
moment = require 'moment'
AWS = require 'aws-sdk'
AWS.config.region = 'ap-northeast-1'

module.exports = (ftppasswd,passiveIp)->
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
    pasvPortRangeStart: 50000
    pasvPortRangeEnd: 51000
    useWriteFile: true
    useReadFile: true
    getInitialCwd: (connection)->
      ''
    getRoot: (user)->
      ''

  server = new ftpd.FtpServer passiveIp, options
  server.on 'client:connected',(conn)->
    username = null
    #console.log "Client connected from #{conn.socket.remoteAddress}"
    conn.on 'command:user',(user,success,failure)->
      username = user
      if /^s[0-9]{4}$/.test username then success() else failure()
    conn.on 'command:pass' ,(pass,success,failure)->
      if pass == ftppasswd
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
  server.listen 21
  console.log 'FTPD listening on port 21'


