cluster = require 'cluster'

if cluster.isMaster
	worker = cluster.fork()
  cluster.on 'exit', (worker,code,signal)->
    console.log "worker #{worker.process.pid} died"
    cluster.fork()
