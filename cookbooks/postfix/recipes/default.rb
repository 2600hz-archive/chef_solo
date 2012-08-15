#
# Author:: Stephen Lum (<stephen@2600hz.com>)
# Cookbook Name:: postfix
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

service "sendmail" do
  action :disable
end

package "sendmail" do
  action :remove
  ignore_failure true
end

package "postfix" do
  action :upgrade
end

service "postfix" do
  supports :restart => true, :reload => true
  action :enable
end

%w{main master}.each do |cfg|
  template "/etc/postfix/#{cfg}.cf" do
    source "#{cfg}.cf.erb"
    owner "root"
    group "root"
    mode 0644
    notifies :restart, resources(:service => "postfix")
  end
end

execute "update-postfix-aliases" do
  command "newaliases"
  action :nothing
end

template "/etc/aliases" do
  source "aliases.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :run, resources("execute[update-postfix-aliases]")
  notifies :reload, resources(:service => "postfix")
end

#service "postfix" do
#  action :start
#end
