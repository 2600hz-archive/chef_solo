#
# Cookbook Name:: bluepill
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

gem_package "activesupport" do
  action :install
#  version "2.3.10"
end
gem_package "blankslate" do
  action :install
#  version "2.1.2.3"
end
gem_package "i18n"
gem_package "daemons" do
  action :install
  version "1.1.8"
end
gem_package "bluepill" do
  action :install
  version "0.0.52"
end

[
  node["bluepill"]["conf_dir"],
  node["bluepill"]["pid_dir"],
  node["bluepill"]["state_dir"]
].each do |dir|
  directory dir do
    owner "root"
    group "root"
  end
end

service "rsyslog" do
  action :nothing
end

template "/etc/rsyslog.d/bluepill.conf" do
  source "bluepill.conf.rsyslog.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[rsyslog]"
end
