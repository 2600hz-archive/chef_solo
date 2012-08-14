#
# Cookbook Name:: yum
# Recipe:: default
#
# Copyright 2010, 2600hz
#
# All rights reserved - Do Not Redistribute
#

e = execute "yum -y update" do
  action :nothing
end

e.run_action(:run)

