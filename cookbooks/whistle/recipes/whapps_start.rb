#
# Cookbook Name:: whistle
# Recipe:: whapps_start
#
# Copyright 2011, 2600hz

execute "start whapps" do
  command "#{node[:whistle][:homedir]}/whistle/whistle_apps/start.sh && sleep 10"
  action :run
  user "whistle"
  environment ({'HOME' => '/opt/whistle'})
  ignore_failure true
end

ruby_block "remove_whapps_start" do
  block do
    Chef::Log.info("Whistle Apps startup completed, removing the destructive recipe[whistle::whapps_start]")
    node.run_list.remove("recipe[whistle::whapps_start]") if node.run_list.include?("recipe[whistle::whapps_start]")
  end
end
