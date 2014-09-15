#
# Cookbook Name:: monitor
# Recipe:: websocket
#
# Copyright 2014, 2600Hz inc.
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

include_recipe "monitor::_websocket"

sensu_check "check_websocket_http" do
  command "check-http.rb -u https://#{node['ipaddress']}:8443 -k --response-code 400"
  handlers ["default"]
  standalone true
  interval 60
  additional(:notification => "Websocket not responding")
end