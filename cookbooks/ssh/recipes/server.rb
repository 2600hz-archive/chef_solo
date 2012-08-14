case node[:platform]
when "ubuntu","debian"
  service "ssh" do
  	supports :restart => true, :reload => true
  	action :enable
  end
else
  service "sshd" do
        supports :restart => true, :reload => true
        action :enable
  end
end 

nodes = search(:node, "*:*")

template "/etc/ssh/known_hosts" do
  source "known_hosts.erb"
  mode 0644
  owner "root"
  group "root"
  variables(:nodes => nodes)
end

template "/etc/ssh/ssh_config" do
  source "ssh_config.erb"
  mode 0644
  owner "root"
  group "root"
end

template "/etc/ssh/sshd_config" do
  source "sshd_config.erb"
  mode 0644
  owner "root"
  group "root"
  case node[:platform]
  when "centos","redhat","fedora"
    notifies :restart, resources(:service => "sshd")
  when "debian","ubuntu"
    notifies :restart, resources(:service => "ssh")
  end
  not_if "grep 'falafel shop' /etc/ssh/sshd_config"
end


case node[:platform]
when "ubuntu","debian"
  service "ssh" do
  	action :start
  end
else
  service "sshd" do
        action :restart
  end
end
