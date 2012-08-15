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

yum_package "kazoo" do
  action :upgrade
  flush_cache [ :before ]
  notifies :restart, resources(:bluepill_service => "whapps")
  notifies :restart, resources(:bluepill_service => "ecallmgr")
end

group "kazoo" do
  gid 5001
end

user "kazoo" do
  comment "Kazoo system user"
  uid "5001"
  gid 5001
  home "#{node[:kazoo][:homedir]}"
  system true
  manage_home true
end

directory "#{node[:kazoo][:homedir]}" do
  owner "kazoo"
  group "kazoo"
  mode "0700"
  action :create
end

template "#{node[:kazoo][:homedir]}/.epm" do
  source "epm.erb"
  owner "kazoo"
  group "kazoo"
  mode "0644"
end

template "#{node[:kazoo][:homedir]}/.bashrc" do
  source "bashrc.erb"
  owner "kazoo"
  group "kazoo"
  mode "0644"
end

template "#{node[:kazoo][:homedir]}/.erlang.cookie" do
  source "erlang.cookie.erb"
  owner "kazoo"
  group "kazoo"
  mode "0600"
end

template "#{node[:kazoo][:kazoo_apps_dir]}/priv/startup.config" do
  source "applications-startup-development.config.erb"
  owner "kazoo"
  group "kazoo"
  mode "0644"
end

template "#{node[:kazoo][:homedir]}/lib/whistle_couch-1.0.0/priv/startup.config" do
  source "whistle_couch-1.0.0_priv_startup.config.erb"
  owner "kazoo"
  group "kazoo"
  mode "0644"
end

template "#{node[:kazoo][:homedir]}/lib/whistle_amqp-1.0.0/priv/startup.config" do
  source "whistle_amqp-1.0.0_priv_startup.config.erb"
  owner "kazoo"
  group "kazoo"
  mode "0644"
end

template "#{node[:kazoo][:homedir]}/ecallmgr/conf/vm.args" do
  source "ecallmgr_vm.args.erb"
  owner "kazoo"
  group "kazoo"
  mode "0644"
end

template "#{node[:kazoo][:homedir]}/ecallmgr/priv/startup.config" do
  source "ecallmgr-startup.config.erb"
  owner "kazoo"
  group "kazoo"
  mode "0644"
  variables :fs_nodes => fs_nodes
end

template "#{node[:kazoo][:kazoo_apps_dir]}/conf/vm.args" do
  source "applications_vm.args.erb"
  owner "kazoo"
  group "kazoo"
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
      command "export ERL_LIBS=#{node[:kazoo][:homedir]}/lib && #{node[:kazoo][:homedir]}/utils/media_importer/media_importer -h 127.0.0.1 -P #{node[:haproxy][:proxy_port]} -u #{node[:couchdb_username]} -p #{node[:couchdb_plaintext_password]} #{node[:kazoo][:homedir]}/confs/system_media/*.wav"
    else
      command "export ERL_LIBS=#{node[:kazoo][:homedir]}/lib && #{node[:kazoo][:homedir]}/utils/media_importer/media_importer -h 127.0.0.1 -P #{node[:haproxy][:proxy_port]} -u #{node[:couchdb_username]} -p #{node[:couchdb_plaintext_password]} #{node[:kazoo][:homedir]}/confs/system_media/*.wav"
    end
    user "kazoo"
    action :run
    environment ({'HOME' => '/opt/kazoo'})
    ignore_failure true
  else 
    command "export ERL_LIBS=#{node[:kazoo][:homedir]}/lib && #{node[:kazoo][:homedir]}/utils/media_importer/media_importer -h 127.0.0.1 -P #{node[:haproxy][:proxy_port]} -u #{node[:couchdb_username]} -p #{node[:couchdb_plaintext_password]} #{node[:kazoo][:homedir]}/confs/system_media/*.wav"
    user "kazoo"
    action :run
    environment ({'HOME' => '/opt/kazoo'})
    ignore_failure true
  end
end

execute "chmod sup" do
  command "chmod +x /opt/kazoo/utils/sup/sup"
end

execute "migrate" do
  command "/opt/kazoo/utils/sup/sup whapps_maintenance migrate"
  ignore_failure true
  action :run
  user "kazoo"
end

execute "updating alias" do
  command "/opt/kazoo/utils/sup/add_alias.sh"
end
