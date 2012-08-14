#
# Cookbook Name:: yumrepo
# Recipe:: vmware-tools 
#
# Copyright 2010, Eric G. Wolfe
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

case node[:platform] when "redhat","centos"
  if node[:platform_version].to_f >= 5 and node[:repo][:vmware][:enabled]

    execute "rpm --import /etc/pki/rpm-gpg/#{node[:repo][:vmware][:key]}" do
      action :nothing
    end

    execute "yum -q makecache" do
      action :nothing
    end

    ruby_block("reload-yum-cache") do
      block do
        Chef::Provider::Package::Yum::YumCache.instance.reload
      end
    end

    package "VMwareTools" do
      action :remove
    end

    execute "/usr/bin/vmware-uninstall-tools.pl" do
      action :run
      only_if {File.exists?("/usr/bin/vmware-uninstall-tools.pl")}
    end

    cookbook_file "/etc/pki/rpm-gpg/#{node[:repo][:vmware][:key]}" do
      mode "0644"
      source node[:repo][:vmware][:key]
      notifies :run, resources(:execute => "rpm --import /etc/pki/rpm-gpg/#{node[:repo][:vmware][:key]}"), :immediately
    end

    template "/etc/yum.repos.d/vmware-tools.repo" do
      mode "0644"
      source "vmware-tools.repo.erb"
      notifies :run, resources(:execute => "yum -q makecache"), :immediately
      notifies(:create, resources('ruby_block[reload-yum-cache]'), :immediately)
    end

    package "vmware-tools-nox" do
      action :install
    end

    package "vmware-tools-common" do
      action :install
    end

    package "vmware-open-vm-tools-common" do
      action :install
    end

    package "vmware-open-vm-tools-nox" do
      action :install
    end

    package "vmware-open-vm-tools-kmod" do
      action :install
    end

    service "vmware-tools" do
      supports :status => true, :restart => true
      action [ :enable, :start ]
    end

    if node[:repo][:vmware][:install_optional]
      package "vmware-open-vm-tools-xorg-drv-display" do
        action :install
      end

      package "vmware-open-vm-tools-xorg-drv-mouse" do
        action :install
      end
    end

  end
end
