#!/usr/bin/env ruby
#This script gives such glorious features for most excellent server running such as check to see if great firewall of iptables is running to defeat imperialist hackers

output =`sudo /sbin/iptables -L`


file = File.open("/etc/sysconfig/test_iptables", "rb")
expected = file.read
file.close


if (output == expected)
  puts "Iptables match OK"
  exit 0
else
  puts "Iptables does not match expected config"
  exit 1
end