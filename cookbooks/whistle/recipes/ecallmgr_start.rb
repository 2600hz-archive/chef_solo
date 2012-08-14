#
# Cookbook Name:: whistle
# Recipe:: ecallmgr_start
#
# Copyright 2011, 2600hz
Chef::Log.debug("YAAAAY]----#{node[:chef_client][:first_run]}")
if node[:chef_client][:first_run] == "done"
 Chef::Log.debug("GO INTO -ECALL RECIPE")

fs_nodes = search(:node, "roles:whistle-fs AND cluster:#{node[:cluster]}")

if node.has_key?("client_id")
  hosts = data_bag_item(:accounts, "#{node[:client_id]}")

  if node.run_list.include?("role[all_in_one]")
  else
    hosts['freeswitch']['servers'].each do |name, ip|
      noah_block "wait for node #{name}" do
        path "http://64.5.99.164:5678/ephemerals/freeswitch/#{node[:client_id]}/#{name}"
        timeout 1200
        retry_interval 5
        on_failure :retry
      end
    end
  end
end

execute "ecallmgr" do
  command "#{node[:whistle][:homedir]}/whistle/ecallmgr/start.sh && sleep 10"
  action :run
  user "whistle"
  environment ({'HOME' => '/opt/whistle'})
  ignore_failure true
end

fs_nodes.each do |n|
  execute "add #{n}" do
    user "whistle"
    command "#{node[:whistle][:whistle_erl_dir]}/ecallmgr_ctl add_fs_node 'freeswitch@#{n[:fqdn]}' "
  end
end
ruby_block "remove_ecallmgr_start" do
  block do
 Chef::Log.debug("REMOVING-ECALL")
    Chef::Log.info("Whistle Apps startup completed, removing the destructive recipe[whistle::whapps_start]")
    node.run_list.remove("recipe[whistle::ecallmgr_start]") if node.run_list.include?("recipe[whistle::ecallmgr_start]")
  end
end

ruby_block "remove_first_start" do
  block do
 Chef::Log.debug("REMOVING-FIRST")
    Chef::Log.info("First Chef-client run completed, removing the destructive recipe[chef-client::first_start]")
    node.run_list.remove("recipe[chef-client::first_start]") if node.run_list.include?("recipe[chef-client::first_start]")
  end
end

ruby_block "remove_recipe_test" do
  block do
 Chef::Log.debug("REMOVING-TEST")
    Chef::Log.info("Removing the destructive recipe[whistle::test]")
    node.run_list.remove("recipe[whistle::test]") if node.run_list.include?("recipe[whistle::test]")
  end
end

end


if node[:chef_client][:first_run] == "nope"
puts "Nothing to do right now! Wait for the second run..."
end
