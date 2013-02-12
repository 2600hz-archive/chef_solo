#
# Cookbook Name:: chef-monitor
# Recipe:: check_sip
#
# Copyright 2013, Stephen Lum
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
  nagios-plugins-all
  perl-Time-HiRes
].each do |pkg|
  yum_package "#{pkg}"
end


cookbook_file "/usr/lib64/nagios/plugins/check_sip" do
  source "plugins/check_sip"
  mode 0755
end

sensu_check "check_sip" do
  command "PATH=$PATH:/usr/lib64/nagios/plugins:/usr/lib/nagios/plugins check_sip -u sip:1234@#{node['ipaddress']} -p 5060 -s"
  handlers ["default"]
  subscribers ["sip"]
  interval 30
  additional(:notification => "FreeSWITCH is not running")
end