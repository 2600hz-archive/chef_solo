#
# Cookbook Name:: rabbitmq
# Recipe:: default
#
# Copyright 2009, Benjamin Black
# Copyright 2009-2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# rabbitmq-server is not well-behaved as far as managed services goes
# we'll need to add a LWRP for calling rabbitmqctl stop
# while still using /etc/init.d/rabbitmq-server start
# because of this we just put the rabbitmq-env.conf in place and let it rip

directory "/etc/rabbitmq/" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

template "/etc/rabbitmq/rabbitmq-env.conf" do
  source "rabbitmq-env.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

service "rabbitmq-server" do
  start_command "setsid /etc/init.d/rabbitmq-server start"
  stop_command "setsid /etc/init.d/rabbitmq-server stop"
  restart_command "setsid /etc/init.d/rabbitmq-server restart"
  status_command "setsid /etc/init.d/rabbitmq-server status"
  supports :status => true, :restart => true
end

case node[:platform]
when "debian", "ubuntu"
  apt_repository "rabbitmq" do
    uri "http://www.rabbitmq.com/debian/"
    distribution "testing"
    components ["main"]
    key "http://www.rabbitmq.com/rabbitmq-signing-key-public.asc"
    action :add
  end
  package "rabbitmq-server"

when "redhat", "centos", "scientific","amazon"
  package "rabbitmq-server" do
    action :remove
    not_if "rpm -qa | grep rabbitmq-server-2.8"
  end

  package "rabbitmq-server" do
    action :upgrade
  end

  service "rabbitmq-server" do
    action :stop
  end

  template "/var/lib/rabbitmq/.erlang.cookie" do
    source "doterlang.cookie.erb"
    owner "rabbitmq"
    group "rabbitmq"
    mode 0400
  end

  template "/usr/lib/rabbitmq/lib/rabbitmq_server-2.8.4/sbin/rabbitmqctl" do
    source "rabbitmqctl.erb"
    owner "root"
    group "root"
    mode 0755
  end

  template "/usr/lib/rabbitmq/lib/rabbitmq_server-2.8.4/sbin/rabbitmq-server" do
    source "rabbitmq-server.erb"
    owner "root"
    group "root"
    mode 0755
  end

  service "rabbitmq-server" do
    action :start
  end

  if node[:platform_version].to_i > 5
    package "qpidd" do
      action :remove
    end

    execute "rm /etc/init.d/rabbitmq-server" do
      ignore_failure true
    end

    template "/var/lib/rabbitmq/.erlang.cookie" do
      source "doterlang.cookie.erb"
      owner "rabbitmq"
      group "rabbitmq"
      mode 0400
    end

    execute "start rabbitmq-server" do
      action :nothing
    end

    template "/etc/init/rabbitmq-server.conf" do
      mode "0644"
      source "rabbitmq-server.conf.upstart.erb"
      notifies :run, resources(:execute => "start rabbitmq-server")
    end
  end
end

case node[:platform]
when "debian", "ubuntu"
  service "rabbitmq-server" do
    action [:enable, :start]
  end
when "redhat", "centos", "scientific","amazon"
  if node[:platform_version].to_i <= 5
    service "rabbitmq-server" do
      action [ :enable, :start ]
    end
  end
end
