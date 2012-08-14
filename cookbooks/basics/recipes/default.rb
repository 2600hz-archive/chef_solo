#
# Cookbook Name:: basics
# Recipe:: default
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

case node[:platform]
when "centos", "redhat", "fedora", "amazon"
  if node[:platform_version].to_i <= 5
    packages = %w[
      git screen dstat gdb strace ngrep vim-enhanced tcpdump vixie-cron dialog nc
    ]
  else
    packages = %w[
      git screen dstat gdb strace vim-enhanced tcpdump dialog nc cronie
    ]
  end
when "ubuntu", "debian"
  packages = %w[
    htop git-core screen dstat gdb strace vim ngrep
  ]
end

packages.each do |pkg|
  package pkg do
    action :install
  end
end

package "logwatch" do
  action :remove
end

execute "remove aegis repo" do
  command "rm -f /etc/yum.repos.d/aegis*"
end

#service "iptables" do
#	action [:stop, :disable]
#	ignore_failure true
#end

template "/etc/yum/yum-updatesd.conf" do
  source "yum-updatesd.conf.erb"
  owner "root"
  group "root"
  mode 0644
  only_if {File.exists?("/etc/yum/yum-updatesd.conf")}
end
