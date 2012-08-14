#
# Cookbook Name:: whistle
# Recipe:: whistle_apps
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

fs_nodes = node[:fqdn]

execute "install keychain" do
  not_if "rpm -qa | grep keychain"
  command "yum --enablerepo=rpmforge install -y keychain"
end

group "whistle" do
  gid 5001
end

user "whistle" do
  comment "Whistle system user"
  uid "5001"
  gid 5001
  home "#{node[:whistle][:homedir]}"
  system true
  manage_home true
end

directory "#{node[:whistle][:homedir]}" do
  owner "whistle"
  group "whistle"
  mode "0700"
  action :create
end

directory "#{node[:whistle][:homedir]}/.ssh" do
  owner "whistle"
  group "whistle"
  mode "0700"
  action :create
  recursive true
end

cookbook_file "#{node[:whistle][:homedir]}/.ssh/id_dsa" do
  source "id_dsa"
  owner "whistle"
  group "whistle"
  mode "0600"
end

cookbook_file "#{node[:whistle][:homedir]}/.ssh/id_dsa.pub" do
  source "id_dsa.pub"
  owner "whistle"
  group "whistle"
  mode "0600"
end

template "#{node[:whistle][:homedir]}/.ssh/config" do
  source "ssh_config.erb"
  owner "whistle"
  group "whistle"
  mode "0644"
end

template "#{node[:whistle][:homedir]}/.ssh/known_hosts" do
  source "known_hosts.erb"
  owner "whistle"
  group "whistle"
  mode "0644"
end

template "#{node[:whistle][:homedir]}/.epm" do
  source "epm.erb"
  owner "whistle"
  group "whistle"
  mode "0644"
end

template "#{node[:whistle][:homedir]}/.bashrc" do
  source "bashrc.erb"
  owner "whistle"
  group "whistle"
  mode "0644"
end

template "#{node[:whistle][:homedir]}/.erlang.cookie" do
  source "erlang.cookie.erb"
  owner "whistle"
  group "whistle"
  mode "0600"
end

git "#{node[:whistle][:homedir]}/whistle" do
  reference node[:whistle_branch]
  destination "#{node[:whistle][:homedir]}/whistle"
  repository "#{node[:whistle_git_url]}"
  user "whistle"
  group "whistle"
  action :sync
end

template "#{node[:whistle][:whistle_apps_dir]}/priv/startup.config" do
  source "applications-startup-development.config.erb"
  owner "whistle"
  group "whistle"
  mode "0644"
end

template "#{node[:whistle][:homedir]}/whistle/lib/whistle_couch-1.0.0/priv/startup.config" do
  source "whistle_couch-1.0.0_priv_startup.config.erb"
  owner "whistle"
  group "whistle"
  mode "0644"
end

template "#{node[:whistle][:homedir]}/whistle/lib/whistle_amqp-1.0.0/priv/startup.config" do
  source "whistle_amqp-1.0.0_priv_startup.config.erb"
  owner "whistle"
  group "whistle"
  mode "0644"
end

template "#{node[:whistle][:homedir]}/whistle/ecallmgr/conf/vm.args" do
  source "ecallmgr_vm.args.erb"
  owner "whistle"
  group "whistle"
  mode "0644"
end

template "#{node[:whistle][:homedir]}/whistle/ecallmgr/priv/startup.config" do
  source "ecallmgr-startup.config.erb"
  owner "whistle"
  group "whistle"
  mode "0644"
  variables :fs_nodes => fs_nodes
end

template "#{node[:whistle][:whistle_apps_dir]}/conf/vm.args" do
  source "applications_vm.args.erb"
  owner "whistle"
  group "whistle"
  mode "0644"
end

execute "media_importer" do
  if node[:cloud][:provider] == "rackspace"
    command "export ERL_LIBS=#{node[:whistle][:homedir]}/whistle/lib && #{node[:whistle][:homedir]}/whistle/utils/media_importer/media_importer -h #{node[:cloud][:private_ips][0]} -P #{node[:haproxy][:proxy_port]} -u #{node[:couchdb_username]} -p #{node[:couchdb_plaintext_password]} #{node[:whistle][:homedir]}/whistle/confs/system_media/*.wav"
  else
    command "export ERL_LIBS=#{node[:whistle][:homedir]}/whistle/lib && #{node[:whistle][:homedir]}/whistle/utils/media_importer/media_importer -h #{node[:ipaddress]} -P #{node[:haproxy][:proxy_port]} -u #{node[:couchdb_username]} -p #{node[:couchdb_plaintext_password]} #{node[:whistle][:homedir]}/whistle/confs/system_media/*.wav"
  end
  user "whistle"
  action :run
  environment ({'HOME' => '/opt/whistle'})
  ignore_failure true
end
