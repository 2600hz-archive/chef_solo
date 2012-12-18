#
# Cookbook Name:: redis
# Recipe:: _server_service

redis_service = case node['platform_family']
when "debian"
  "redis-server"
when "rhel", "fedora"
  "redis"
else
  "redis"
end

service "redis" do
  service_name redis_service
  action [ :enable, :start ]
end
