require 'net/ftp'
require 'rubygems'
require 'parallel'


def putcsv(path,id)
	puts path
	Net::FTP.open('52.68.64.73') do |ftp|
	  ftp.login("s#{id}",'1234')
	  ftp.passive = true
	  # ftp.nlst do |f|
	  # 	puts File.basename f
	  # end
	  (Dir.glob("#{path}/*").map{|f| File.basename f} - ftp.nlst).each do |c|
	  	begin
		  	ftp.putbinaryfile("#{path}/#{c}")
		rescue =>e
			puts e
			puts "#{c} put err."
		end
	  end
	end
end


list = Dir.glob('//neptune/glory/12??').map { |f| {id: f.match(/[0-9]{4}$/).to_s,file:f}}
Parallel.each(list, in_threads: 4) {|o|
  puts "start upload #{o}"
  putcsv(o[:file],o[:id])
  puts "end upload: #{o}"
}