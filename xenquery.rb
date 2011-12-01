#!/usr/bin/env ruby

require 'rubygems'
require 'net/ssh'

filename = 'hosts.txt'
hosts_file_opened = File.open(filename)
hosts = hosts_file_opened.read()

username = 'root'

puts "Command examples: xm list, xen-list-images, etc."
print "Command: "
cmd = gets.chomp()
puts

hosts.each do |host|
  begin
    Net::SSH.start( host.chomp , username, :timeout => 10) do |ssh|
      results = ssh.exec! cmd
      puts "#" * 10
      puts "# Results for #{host}"
      puts "Exit Status: #{results}"
      puts
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
