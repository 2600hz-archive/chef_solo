#
# Cookbook Name:: basics
# Recipe:: iptables_disable 
#
# Copyright 2011, 2600hz, Inc.
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

service "iptables" do
	action [:stop, :disable]
	ignore_failure true
end

ruby_block "remove_iptables_disable" do
  block do
    Chef::Log.info("Removing iptables_disable recipe from run_list")
    node.run_list.remove("recipe[basics::iptables_disable]") if node.run_list.include?("recipe[basics::iptables_disable]")
  end
end
