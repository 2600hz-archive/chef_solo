#
# Cookbook Name:: chef-monitor
# Recipe:: ecallmgr
#
# Copyright 2013, 2600hz, inc
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
  check-ecallmgr.rb
].each do |check|
  cookbook_file "/etc/sensu/plugins/#{check}" do
  source "plugins/#{check}"
  mode 0755
  end
end

sensu_check "check_ecallmgr_process" do
  command "check-procs.rb -p '-name ecallmgr' -C 1 -w 1"
  handlers ["default"]
  subscribers ["kazoo"]
  interval 60
  additional(:notification => "eCallManager is not running")
end

sensu_check "check-ecallmgr" do
  command "check-ecallmgr.rb"
  handlers ["default"]
  subscribers ["kazoo"]
  interval 60
  additional(:notification => "Some FreeSWITCH nodes are not connected to ecallmgr")
end
