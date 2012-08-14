#
# Cookbook Name:: hosts
# Recipe:: client
#
# Copyright 2011, 2600hz
#
#

#app_hosts = search(:node, "client_id:#{node[:client_id]} AND roles:whistle-apps")
if node.run_list.include?("role[all_in_one]")
  template "/etc/hosts" do
    source "hosts.all_in_one.erb"
    owner "root"
    group "root"
    mode 0644
    not_if "grep 'falafel shop' /etc/hosts"
  end
else
  app_hosts = search(:node, "client_id:#{node[:client_id]} AND roles:whistle-apps")
  hosts = data_bag_item(:accounts, "#{node[:client_id]}")
  template "/etc/hosts" do
    source "clients_hosts.erb"
    owner "root"
    group "root"
    mode 0644
    variables(
      :db_hosts => hosts['bigcouch']['servers'],
      :fs_hosts => hosts['freeswitch']['servers'],
      :app_hosts => app_hosts
    )
    not_if "grep 'falafel shop' /etc/hosts"
  end
end

execute "hostname --file /etc/hostname" do
  action :nothing
end

file "/etc/hostname" do
  content "#{node[:fqdn]}"
  notifies :run, resources(:execute => "hostname --file /etc/hostname"), :immediately
end
