#!/usr/bin/env ruby

# Author: Lance Lakey
# Purpose: Present the user with a menu of Xen related commands to run against a group of Xen Dom0's
# The ruby gem highline does the work of creating the menu
#
# Requires a file in the same directory named hosts.txt
# hosts.txt should contain one ip address or one hostname per line
#
# Authentication:
# This script can be easily modified to use a password
# This script currently assumes authentication with SSH keys

require 'rubygems'
require 'net/ssh'
require 'highline/import'

filename = './hosts.txt'
hosts_file_opened = File.open(filename)
hosts = hosts_file_opened.read()

username = 'root'

# command is a local variable
# @command is an instance variable

choose do |menu|
  #menu.shell  = true
  #menu.choice(:xmlist, "xm list") do say("Good!") end
  menu.choice(:'xm list') do |command|
    @command = command
  end 
  menu.choice(:'xm info') do |command|
    @command = command
  end 
  menu.choice(:'xen-list-images') do |command|
    @command = command
  end 
end


puts
hosts.each do |host|
  begin
    Net::SSH.start( host.chomp , username, :timeout => 10) do |ssh|
      results = ssh.exec! @command
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
