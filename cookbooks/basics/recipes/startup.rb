#
# Cookbook Name:: basics
# Recipe:: startup
#
# Copyright 2011, 2600hz, Inc.
#
#

%w{ rabbitmq-server ecallmgr whapps bigcouch }.each do |service|
  execute "remove #{service} from " do
    command "chkconfig --del #{service}"
    ignore_failure true
  end
end

template "/etc/rc.d/rc.local" do
  source "rc.local.erb"
  owner "root"
  group "root"
  mode "0755"
end
