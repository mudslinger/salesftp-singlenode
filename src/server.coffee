AWS = require 'aws-sdk'

ec2 = new AWS.EC2
  apiVersion: '2014-10-01'
  accessKeyId: process.env.accessKeyId
  secretAccessKey: process.env.secretAccessKey
  region: process.env.ec2region

metadata = new AWS.MetadataService

metadata.request '/latest/meta-data/instance-id',(err,instanceid)->
  console.log err if err
  unless err
    console.log instanceid
    ec2.associateAddress
      AllocationId: 'eipalloc-ef906c8a'
      AllowReassociation: true
      DryRun: false
      InstanceId: instanceid
      (err,data)->
        require('./ftp-service')(err,data)
