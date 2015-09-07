require 'net/ftp'
require 'rubygems'
require 'parallel'


def putcsv(path,id)
	puts path
	Net::FTP.open('52.68.64.73') do |ftp|
	  ftp.login("s#{id}",'1234')
	  ftp.passive = true
	  ftp.list do |f|
	  	puts f
	  end
	  # Dir.glob("#{path}/*").each do |c|
	  # 	ftp.putbinaryfile(c)
	  # end
	end
end


list = Dir.glob('//neptune/glory/????').map { |f| {id: f.match(/[0-9]{4}$/).to_s,file:f}}
Parallel.each(list, in_threads: 3) {|o|
  puts "start upload #{o}"
  putcsv(o[:file],o[:id])
  puts "end upload: #{o}"
}