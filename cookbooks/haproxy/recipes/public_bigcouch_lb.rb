#
# Cookbook Name:: haproxy
# Recipe:: public_bigcouch_lb
#
# Copyright 2011, 2600hz 
#
#

hosts = data_bag_item('accounts', node.client_id)

package "haproxy" do
  action :install
end

template "/etc/default/haproxy" do
  source "haproxy-default.erb"
  owner "root"
  group "root"
  mode 0644
end

service "haproxy" do
  supports :restart => true, :status => true, :reload => true
  action [:enable]
end

template "/etc/haproxy/haproxy.cfg" do
  source "haproxy-app_lb.cfg.erb"
  owner "root"
  group "root"
  mode 0644
  not_if "grep 'falafel shop' /etc/haproxy/haproxy.cfg"
  variables :hosts => hosts 
  notifies :restart, resources(:service => "haproxy"), :immediately
end

template "/etc/sysconfig/rsyslog" do
  source "haproxy-rsyslog.erb"
  owner "root"
  group "root"
  mode 0644
end
