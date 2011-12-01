#!/usr/bin/env ruby

require 'rubygems'
require 'net/ssh'

filename = 'hosts.txt'
hosts_file_opened = File.open(filename)
hosts = hosts_file_opened.read()

print "Username: "
username = gets.chomp()
print "Password: "
system "stty -echo"
password = gets.chomp()
puts
puts
# Note: if a user cancels this script before setting -echo back to echo they won't see anything when they type at the terminal
system "stty echo"

cmd = "xen-list-images"

hosts.each do |host|
  begin
    Net::SSH.start( host.chomp , username, :password => password, :timeout => 10) do |ssh|
      results = ssh.exec! cmd
      puts ""
      puts "#" * 20
      puts "# Results for #{host}"
      puts ""
      puts "#{results}"
    end 
  rescue Timeout::Error  
    puts "Error: Timed out #{host}"
  rescue Errno::EHOSTUNREACH  
    puts "Error: Host unreachable #{host}" 
  rescue Errno::ECONNREFUSED  
    puts "Error: Connection refused #{host}"  
  rescue Net::SSH::AuthenticationFailed  
    puts "Error: Authentication failure #{host}"
  end  
end
