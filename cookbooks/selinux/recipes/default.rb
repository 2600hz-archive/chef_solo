#
# Cookbook Name:: selinux
# Recipe:: default
#
# Copyright 2011, 2600hz 
#
# All rights reserved - Do Not Redistribute
#

execute "disable_selinux" do
        command "echo 0 > /selinux/enforce"
        action :nothing
        ignore_failure true
end

template "/etc/selinux/config" do
        source "config.erb"
        owner "root"
        group "root"
        notifies :run, resources(:execute => "disable_selinux"), :immediately
end
