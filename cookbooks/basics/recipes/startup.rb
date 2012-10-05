#
# Cookbook Name:: basics
# Recipe:: startup
#
# Copyright 2012, 2600hz, Inc.
#
#

execute "rvm wrapper 1.8.7@default bootup bluepill"

template "/etc/rc.d/rc.local" do
  source "rc.local.erb"
  owner "root"
  group "root"
  mode "0755"
end
