#
# Cookbook Name:: bigcouch
# Recipe:: cluster
#
# Copyright 2011, 2600hz
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
#
# This recipe is run when someone deploys a 7-server deployment to setup the BigCouch nodes.
# It is run in addition to the default.rb recipe
#

members = data_bag('accounts')

Chef::Log.info("#################################");
Chef::Log.info("## Joining BigCouch to Cluster ##");
Chef::Log.info("#################################");

members.each do |fqdn, ipaddress|
  http_request "adding #{fqdn} to cluster" do
    action :put
    url "http://0.0.0.0:5986/nodes/bigcouch@#{fqdn}"
    message :data => ""
    ignore_failure true
  end
end

Chef::Log.info("#####################################");
Chef::Log.info("## BigCouch Now Joined to Cluster  ##");
Chef::Log.info("#####################################");


