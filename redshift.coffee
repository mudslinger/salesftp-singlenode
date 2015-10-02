pg = require 'pg'
constring = "postgres://administrator:muVoTtKjLizpqhHuPVnsRmBrkeQA4Uak@yamaokaya.cs2s0ljbb5f8.ap-northeast-1.redshift.amazonaws.com:5439/yamaokaya"

client = new pg.Client(conString)
client.connect (err)->
	console.log err if err

query = client.query "select * from test"

var pg = require('pg');
 
var conString = "tcp://<ユーザー名>:<パスワード>@<endpoint>:<ポート番号>/<DB名>";
var client = new pg.Client(conString);
client.connect(function(err) {
    if(err) console.error(err);
});
var query = client.query("CREATE TABLE data_from_s3(id integer,name varchar(50), timestamp timestamp not null default current_timestamp)");
 
query.on('error', function(error) {
    console.error(error);
});
query.on('end', function(row, error) {
    client.end();
});