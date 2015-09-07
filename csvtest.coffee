AWS = require 'aws-sdk'
csv = require 'csv'
moment = require 'moment'
Stream = require 'stream'

class S3Stream extends Stream
	constructor: (@key,@s3)->
		@writeable = true
		@buf = []

	write: (data)=>
		@buf.push data.toString()
		true
	end: (data)=>
		@write data if data
		@writeable = false
		@s3.putObject 
			Key: @key,Body: @buf.join('')
			(err,d)->
				console.log err if err
				console.log d


AWS.config.region = 'ap-northeast-1'

s3 = new AWS.S3
    params:
      s3_endpoint: 's3-ap-northeast-1.amazonaws.com' 
      Bucket: 'sales.wb.yamaokaya.com'

#TODO tmp
shop_id = "1238"
file_name = "1238/2015/TH09041.CSV"
idx = 0

stream = new S3Stream('1238/2015/TH09041.2.CSV',s3)
s3.getObject Key: file_name
	.createReadStream()
	.pipe csv.parse()
	.pipe csv.transform (row)->
		#console.log row
		idx += 1
		[
			shop_id
			parseInt(row[0]) * 100000 + parseInt(row[6]) * 10 + idx % 10
			1
			#TODO ファイル名のYesterday
			moment(row[2],'YYMMDDHHmmss').format("YYYY-MM-DD")
			parseInt(row[10])
			moment(row[2],'YYMMDDHHmmss').format("YYYY-MM-DD HH:mm:ss")
			parseInt(row[18])
			parseInt(row[20])
			parseInt(row[19])
			0
			"No.#{row[10]}"
      file_name
		] if row[1] == "0"
	.pipe csv.stringify()
	.pipe stream