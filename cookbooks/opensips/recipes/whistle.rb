#
# Cookbook Name:: opensips
# Author:: Stephen Lum <stephen@2600hz.com>
# Recipe:: whistle
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

nodes = search(:node, "cluster:#{node[:cluster]} AND roles:whistle-fs")
devnodes = search(:node, "roles:development AND roles:whistle-fs")

case node[:platform]
when "centos", "redhat", "fedora"
  packages = %w[ opensips ]

  packages.each do |pkg|
    package pkg do
      action :install
      version "1.6.4-8"
      options "--disablerepo=epel"
    end
  end
  
end

service "opensips" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

service "opensips-dispatcher" do
  supports :reload => true
  reload_command "/etc/opensips/dispatcher.sh -r"
  action :nothing
end

template "/etc/opensips/opensips.cfg" do
  source "opensips.cfg.erb"
  owner "root"
  group "root"
  mode 0600
  notifies :restart, resources(:service => "opensips")
  not_if "grep 'falafel shop' /etc/opensips/opensips.cfg"
end 

template "/etc/opensips/dispatcher.list" do
  source "dispatcher.list.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, resources(:service => "opensips-dispatcher")
  variables :nodes => nodes, :devnodes => devnodes
end

template "/etc/opensips/dispatcher.sh" do
  source "dispatcher.sh.erb"
  owner "root"
  group "root"
  mode 0755
end

template "/etc/opensips/opensipsctl" do
  source "opensipsctl.erb"
  owner "root"
  group "root"
  mode 0755
end

template "/etc/init.d/opensips" do
  source "opensips-init.erb"
  owner "root"
  group "root"
  mode 0755
end

template "/etc/rsyslog.d/opensips.conf" do
  source "opensips.conf.rsyslog.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "rsyslog"), :delayed
end
