#
# Cookbook Name:: chef-monitor
# Recipe:: check_opensips
#
# Copyright 2013 2600hz Inc. <xavier@2600hz.com>
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

=begin
cookbook_file "etc/sensu/plugins/check_sip.rb" do
  source "plugins/check_sip.rb"
  mode 0755
end

sensu_check "check_sip_5060" do
  command "check_sip.rb -H #{node['fqdn']} -u sip:1234@#{node['ipaddress']} -p 5060"
  handlers ["default"]
  subscribers ["opensips"]
  interval 60
  additional(:notification => "UDP 5060 is not responding")
end

sensu_check "check_sip_7000" do
  command "check_sip.rb -H #{node['fqdn']} -u sip:1234@#{node['ipaddress']} -p 7000"
  handlers ["default"]
  subscribers ["opensips"]
  interval 60
  additional(:notification => "UDP 7000 is not responding")
end
=end

sensu_check "opensips_process" do
  command "check-procs.rb -p 'opensips' -C 1 -c 30"
  handlers ["default"]
  subscribers ["opensips"]
  interval 30
  additional(:notification => "OpenSIPs is not running")
end

