#
# Cookbook Name:: chef-monitor
# Recipe:: base_checks
#
# Copyright 2013, Stephen Lum, 2600hz inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "chef-monitor::default"

%w[
	check-banner.rb
	check-disk.rb
	check-ram.rb
	check_uptime.sh
	check-load.rb
	load-metrics.rb
	metrics-netstat-tcp.rb
	metrics-net-packets.rb
	vmstat-metrics.rb
].each do |check|
	cookbook_file "/etc/sensu/plugins/#{check}" do
  	source "plugins/#{check}"
  	mode 0755
	end
end

sensu_check "check_disk" do
  command "check-disk.rb -w 80 -c 90"
  handlers ["default"]
  subscribers ["all"]
  interval 60
end

sensu_check "check-ram" do
  command "check-ram.rb"
  handlers ["default"]
  subscribers ["all"]
  interval 30
end

sensu_check "vmstat-metrics" do
  command "vmstat-metrics.rb"
  handlers ["graphite"]
  subscribers ["all"]
  interval 30
  type "metric"
end

=begin
sensu_check "load_metrics" do
  command "load-metrics.rb --scheme stats.:::name:::"
  handlers ["graphite"]
  subscribers ["all"]
  interval 30
  type "metric"
end
=end

sensu_check "check_ssh" do
  command "check-banner.rb -p #{node['ssh_port'] || 22}"
  handlers ["default"]
  subscribers ["all"]
  interval 60
end

=begin
sensu_check "metrics-netstat-tcp" do
  command "metrics-netstat-tcp.rb --scheme stats.:::name:::"
  handlers ["graphite"]
  subscribers ["all"]
  interval 30
  type "metric"
end

sensu_check "metrics-net-packets" do
  command "metrics-net-packets.rb --scheme stats.:::name:::"
  handlers ["graphite"]
  subscribers ["all"]
  interval 30
  type "metric"
end
=end

sensu_check "check_uptime" do
  command "check_uptime.sh"
  handlers ["default"]
  subscribers ["all"]
  interval 60
  additional(:notification => "Uptime check failed")
end

=begin
sensu_check "check_iptables" do
  command "check_iptables.rb"
  handlers ["default"]
  subscribers ["all"]
  interval 60
  additional(:notification => "Iptables check failed")
end
=end

sensu_check "check-load" do
  command "check-load.rb -w 4,8,20 -c 6,15,30"
  handlers ["default"]
  subscribers ["all"]
  interval 60
end

