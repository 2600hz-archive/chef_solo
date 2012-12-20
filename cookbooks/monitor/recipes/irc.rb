#
# Cookbook Name:: monitor
# Recipe:: irc
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

sensu_gem "carrier-pigeon"

template "/etc/sensu/conf.d/irc.json" do
	source "irc.json.erb"
	owner "sensu"
	group "sensu"
	mode 0644
end

sensu_handler "irc" do
  type "pipe"
  command "irc.rb"
  additional(:irc_server => "irc://sensubot:password@irc.freenode.net:6667#switchfreedom-qa")
end