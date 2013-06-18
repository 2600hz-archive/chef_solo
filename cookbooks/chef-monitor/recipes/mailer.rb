#
# Cookbook Name:: chef-monitor
# Recipe:: mailer
#
# Copyright 2013, 2600hz Inc.
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

service "postfix" do
  supports :status => true, :restart => true, :reload => true
  action :enable
end

service "postfix" do
  action :start
end

sensu_gem "mail" do
  version "2.4.0"
end

cookbook_file "/etc/sensu/handlers/mailer.rb" do
  source "handlers/mailer.rb"
  mode 0755
end

sensu_handler "mailer" do
  type "pipe"
  command "/etc/sensu/handlers/mailer.rb"
end

sensu_snippet "mailer" do
  content({:mail_from => "#{node[:mail_from]}", :mail_to => "#{node[:mail_to]}", :smtp_address => "#{node[:smtp_address]}", :smtp_port => "#{node[:smtp_port]}", :smtp_domain => "#{node[:smtp_domain]}"})
end
