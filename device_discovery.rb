# This script discover devices with custom filters using nmap.
# Usage: ruby device_discovery.rb IP_address
#    ex: ruby device_discovery.rb 192.168.0.1
#    ex: ruby device_discovery.rb 192.168.0.0/24
 
# This script is licensed under MIT License
# (c) 2023 Mocke Tech., LLC.

# https://github.com/ipaddress-gem/ipaddress
# MIT License
require 'optparse'
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

# using optparse
# https://maku77.github.io/ruby/io/optparse.html
flags = {}
flags[ 'alive'] = true
opt = OptionParser.new
opt.banner = "Usage: ruby ./#{__FILE__} [options] network_address or IP address\n" \
             + "   ex: ruby ./#{__FILE__} 192.168.0.0/24" \
             + "   ex: ruby ./#{__FILE__} 192.168.0.1"
opt.on( '-a', '--alive', 'Show alive IP address [default].') { flags[ 'alive'] = true}
opt.on( '-n', '--no-alive', 'Not show alive IP address.') {flags[ 'alive'] = false}
opt.on( '-v', '--verbose', 'Verbose mode.') { flags[ 'verbose'] = true} 
opt.parse!( ARGV)

# Check argument of command line
if ARGV.length != 1
  puts( 'Error: Please specify a network address or an IP address')
  puts( opt.help)
  exit 1
end

begin
    targetNetwork = IPAddress::IPv4.new( ARGV[0])
rescue => e
    puts e.message
end

targetNetwork.each do |addr|
    p addr
    next if (addr == addr.network || addr == addr.broadcast) && addr.prefix != 32
    
    begin
      err_r, err_w = IO.pipe()
      result = IO.popen( "#{nmapCmd} #{addr}", :err=>err_w) do |cmd_io|
        cmd_io.read
      end
    rescue => e
      puts e.message
    end

    outputs = result.split("\n")
    
    puts "#{addr} is alive.\n" if flags[ 'alive'] and NmapFilter.isAlive?( outputs)
    puts "#{addr} \n" if flags[ 'alive'] and flags[ 'verbose'] and (! NmapFilter.isAlive?( outputs))
end
