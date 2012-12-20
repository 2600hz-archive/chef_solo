#
# Cookbook Name:: monitor
# Recipe:: bigcouch
#
# Copyright 2012, Stephen Lum
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

include_recipe "monitor::default"

cookbook_file "/etc/sensu/plugins/check-http.rb" do
  source "plugins/check-http.rb"
  mode 0755
end

sensu_check "bigcouch_process" do
  command "check-procs.rb -p setcookie -C 1"
  handlers ["default"]
  subscribers ["bigcouch"]
  interval 30
  additional(:notification => "BigCouch is not running")
end

sensu_check "bigcouch_http_response" do
  command "check-http.rb -P 5984 -u http://localhost:5984/ -q couchdb"
  handlers ["default"]
  subscribers ["bigcouch"]
  interval 30
  additional(:notification => "BigCouch is not responding to http requests")
end