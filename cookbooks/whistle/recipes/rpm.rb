#
# Cookbook Name:: whistle
# Recipe:: rpm
# Author:: Stephen Lum <stephen@2600hz.com>
#
# Copyright 2011, 2600hz
#

include_recipe "bluepill"
include_recipe "ghostscript"

fs_nodes = data_bag_item('accounts', node.client_id)

bluepill_service "whapps" do
  supports :restart => true, :stop => true, :start => true
end

bluepill_service "ecallmgr" do
  supports :restart => true, :stop => true, :start => true
end

yum_package "whistle" do
  action :upgrade
  flush_cache [ :before ]
  notifies :restart, resources(:bluepill_service => "whapps")
  notifies :restart, resources(:bluepill_service => "ecallmgr")
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

template "/etc/init.d/ecallmgr" do
  source "ecallmgr.init.erb"
  owner "root"
  group "root"
  mode  "0755"
end

template "/etc/init.d/whapps" do
  source "whapps.init.erb"
  owner "root"
  group "root"
  mode  "0755"
end

template "/etc/bluepill/whapps.pill" do
  source "whapps.pill.erb"
end

template "/etc/bluepill/ecallmgr.pill" do
  source "ecallmgr.pill.erb"
end

bluepill_service "whapps" do
  supports :restart => true, :stop => true, :start => true
  action [:load]
end

bluepill_service "ecallmgr" do
  supports :restart => true, :stop => true, :start => true
  action [:load]
end

execute "media_importer" do
  if node.has_key?("cloud")
    if node[:cloud][:provider] == "rackspace"
      command "export ERL_LIBS=#{node[:whistle][:homedir]}/whistle/lib && #{node[:whistle][:homedir]}/whistle/utils/media_importer/media_importer -h 127.0.0.1 -P #{node[:haproxy][:proxy_port]} -u #{node[:couchdb_username]} -p #{node[:couchdb_plaintext_password]} #{node[:whistle][:homedir]}/whistle/confs/system_media/*.wav"
    else
      command "export ERL_LIBS=#{node[:whistle][:homedir]}/whistle/lib && #{node[:whistle][:homedir]}/whistle/utils/media_importer/media_importer -h 127.0.0.1 -P #{node[:haproxy][:proxy_port]} -u #{node[:couchdb_username]} -p #{node[:couchdb_plaintext_password]} #{node[:whistle][:homedir]}/whistle/confs/system_media/*.wav"
    end
    user "whistle"
    action :run
    environment ({'HOME' => '/opt/whistle'})
    ignore_failure true
  else 
    command "export ERL_LIBS=#{node[:whistle][:homedir]}/whistle/lib && #{node[:whistle][:homedir]}/whistle/utils/media_importer/media_importer -h 127.0.0.1 -P #{node[:haproxy][:proxy_port]} -u #{node[:couchdb_username]} -p #{node[:couchdb_plaintext_password]} #{node[:whistle][:homedir]}/whistle/confs/system_media/*.wav"
    user "whistle"
    action :run
    environment ({'HOME' => '/opt/whistle'})
    ignore_failure true
  end
end

execute "chmod sup" do
  command "chmod +x /opt/whistle/whistle/utils/sup/sup"
end

execute "migrate" do
  command "/opt/whistle/whistle/utils/sup/sup whapps_maintenance migrate"
  ignore_failure true
  action :run
  user "whistle"
end

execute "updating alias" do
  command "/opt/whistle/whistle/utils/sup/add_alias.sh"
end
