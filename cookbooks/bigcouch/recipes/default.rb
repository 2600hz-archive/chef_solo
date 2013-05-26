#
# Cookbook Name:: bigcouch
# Recipe:: default
#
# Copyright 2011, Cloudant
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

Chef::Log.info("##############################################");
Chef::Log.info("## Installing BigCouch RPM and Dependencies ##");
Chef::Log.info("## (Includes SpiderMonkey and OpenSSL)      ##");
Chef::Log.info("##############################################");

include_recipe "libicu::default"
include_recipe "spidermonkey::default"
include_recipe "bluepill"

package "bigcouch" do
  action :upgrade
  options "--enablerepo=epel"
end

template "/etc/bluepill/bigcouch.pill" do
  source "bigcouch.pill.erb"
end

directory node[:bigcouch][:database_dir] do
  owner "bigcouch"
  group "bigcouch"
  recursive true
  mode "0755"
end
 
directory node[:bigcouch][:view_index_dir] do
  owner "bigcouch"
  group "bigcouch"
  recursive true
  mode "0755"
end

file "/var/log/bigcouch.log" do
  owner "bigcouch"
  group "bigcouch"
  mode "0755"
  action :create_if_missing
  notifies :restart, "service[bigcouch]"
end

template "/opt/bigcouch/etc/local.ini" do
  source "local_ini.erb"
  owner "bigcouch"
  group "bigcouch"
  mode 0644
  notifies :restart, "service[bigcouch]"
end

template "/etc/security/limits.d/bigcouch.limits.conf" do
  source "bigcouch.limits.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[bigcouch]"
end

template "/opt/bigcouch/etc/vm.args" do
  source "vm_args.erb"
  owner "bigcouch"
  group "bigcouch"
  mode 0644
  notifies :restart, "service[bigcouch]"
end

service "bigcouch" do
  supports :restart => true, :start => true, :stop => true
  restart_command "bluepill bigcouch stop; bluepill bigcouch quit; bluepill load /etc/bluepill/bigcouch.pill; bluepill bigcouch start"
  stop_command "bluepill bigcouch stop; bluepill bigcouch quit"
  start_command "bluepill load /etc/bluepill/bigcouch.pill; bluepill bigcouch start"
  action :start
end

execute "bluepill_load" do
  command "bluepill load /etc/bluepill/bigcouch.pill"
  action :run
end

Chef::Log.info("##############################");
Chef::Log.info("## Done Installing BigCouch ##");
Chef::Log.info("##############################");
