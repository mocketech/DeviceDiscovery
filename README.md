# Device Discovery on IP network without pinging

### Summary
このツールはnmapコマンドを利用して、指定したネットワーク上にあるデバイスを検索するためのものです。
ネットワークを指定したうえで、オプション無しで実行すると、当該ネットワークの中で何らかの応答をする
IPアドレスを答えます。オプションの指定により、生きているIPアドレスに関する様々な情報を提供できる
要にする予定です。

### Requirements

* Any linux/*nix system including WSL
* ruby 3.0 or above
* nmap 7.80 or above
* ipaddress-gem/ipaddress 0.8.3 or above

### Building

Do following the script.

```
$ git clone https://github.com/mocketech/DeviceDiscovery.git
$ cd DeviceDiscovery
$ bundle install
```

### Running

Usage: ruby ./device_discovery.rb netowrk-address or IP address
Example: ruby ./device_discovery.rb 192.168.0.0/24
Example: ruby ./device_discovery.rb 192.168.100.7

### Configure

No configuration file so far.

### LICENSE

MIT License.

