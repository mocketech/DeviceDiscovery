# This script discover devices with custom filters using nmap.
# Usage: ruby device_discovery.rb IP_address
#    ex: ruby device_discovery.rb 192.168.0.1
#    ex: ruby device_discovery.rb 192.168.0.0/24
 
# This script is licensed under MIT License
# (c) 2023 Mocke Tech., LLC.

# https://github.com/ipaddress-gem/ipaddress
# MIT License
require 'ipaddress' 

class NmapFilter
  def self.isAlive?( nmapResult)
    nmapResult.each do |line|
      return true if ! line.match( /^PORT[[:space:]]+STATE[[:space:]]+SERVICE[[:space:]]+VERSION[[:space:]]*$/).nil?
      return true if ! line.match( /^[0-9]+\/tcp/).nil?
      return true if ! line.match( /^[0-9]+\/udp/).nil?
      return true if ! line.match( /^Service Info:/).nil?
      return true if ! line.match( /^Host script results:[[:space:]]*$/).nil?
    end

    return false
  end
end

# Definition
nmapCmd = "/usr/bin/nmap -Pn -F -A"

# Check argument of command line
if ARGV.length != 1
    puts "Usage: ruby #{File.basename( __FILE__)} Network_Address"
    puts "   ex: ruby #{File.basename( __FILE__)} 192.168.0.0/24"
end

begin
    targetNetwork = IPAddress::IPv4.new( ARGV[0])
rescue => e
    puts e.message
end

targetNetwork.each do |addr|
    next if (addr == addr.network || addr == addr.broadcast) && addr.prefix != 32
    
    err_r, err_w = IO.pipe()
    result = IO.popen( "#{nmapCmd} #{addr}", :err=>err_w) do |cmd_io|
      cmd_io.read
    end

    # pp $?
    # err_w.close
    # pp err_r.read

    outputs = result.split("\n")
    
    puts "#{addr} is alive.\n" if NmapFilter.isAlive?( outputs)

    #outputs.each do |line|
    #  puts line
    #end
end
