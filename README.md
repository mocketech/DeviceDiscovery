# Device Discovery on IP network without pinging

### Summary
This tool is for discovering devices on specified IP netowrk using nmap without ping. This answers IP addresses if they response something when  network address is specified with no option. In the future, this tool will answer various information related to alive IP addresses.

### Requirements

* Any linux/*nix system including WSL
* ruby 3.0 and above
* bundler 2.4.5 and above
* nmap 7.80 and above
* ipaddress-gem/ipaddress 0.8.3 and above

### Building

Do following the script.

```
$ git clone https://github.com/mocketech/DeviceDiscovery.git
$ cd DeviceDiscovery
$ bundle install
```

### How to run

```
Usage: ruby ./device_discovery.rb netowrk-address or IP address
   ex) ruby ./device_discovery.rb 192.168.0.0/24
       ruby ./device_discovery.rb 192.168.100.7
```

### Outputs

```
$ ruby .device_discovery.rb 192.168.0.0/24
192.168.0.1 alive.
192.168.0.15 alive.
192.168.0.129 alive.
...
```

### Configure

No configuration file so far.

### LICENSE

MIT License.

