hosts = search(:node, "*:*")

template "/etc/hosts" do
  source "hosts.erb"
  owner "root"
  group "root"
  mode 0644
  variables(:hosts => hosts)
  not_if "grep 'falafel shop' /etc/hosts"
end
