#
# Cookbook Name:: basics
# Recipe:: startup
#
# Copyright 2012, 2600hz, Inc.
#
#

template "/etc/rc.d/rc.local" do
  source "rc.local.erb"
  owner "root"
  group "root"
  mode "0755"
end
