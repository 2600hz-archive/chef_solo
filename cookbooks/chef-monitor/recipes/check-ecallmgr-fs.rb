#
# Cookbook Name:: chef-monitor
# Recipe:: check-ecallmgr-fs
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

cookbook_file "etc/sensu/plugins/check-ecallmgr-fs.sh" do
  source "plugins/check-ecallmgr-fs.sh"
  mode 0755
end

sensu_check "check-ecallmgr-fs" do
  command "check-ecallmgr-fs.sh"
  handlers ["default"]
  subscribers ["sip"]
  interval 60
  additional(:notification => "Ecallmgr-fs check failed")
end