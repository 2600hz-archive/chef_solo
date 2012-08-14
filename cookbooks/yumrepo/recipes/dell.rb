#
# Cookbook Name:: yumrepo
# Recipe:: dell
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
  if node[:platform_version].to_f >= 5 and node[:repo][:dell][:enabled]

    execute "rpm --import /etc/pki/rpm-gpg/#{node[:repo][:dell][:key]}" do
      action :nothing
    end

    execute "rpm --import /etc/pki/rpm-gpg/#{node[:repo][:dell][:libsmbios_key]}" do
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

    cookbook_file "/etc/pki/rpm-gpg/#{node[:repo][:dell][:key]}" do
      mode "0644"
      source node[:repo][:dell][:key]
      notifies :run, resources(:execute => "rpm --import /etc/pki/rpm-gpg/#{node[:repo][:dell][:key]}"), :immediately
    end

    cookbook_file "/etc/pki/rpm-gpg/#{node[:repo][:dell][:libsmbios_key]}" do
      mode "0644"
      source node[:repo][:dell][:libsmbios_key]
      notifies :run, resources(:execute => "rpm --import /etc/pki/rpm-gpg/#{node[:repo][:dell][:libsmbios_key]}"), :immediately
    end

    template "/etc/yum.repos.d/dell-omsa-repository.repo" do
      mode "0644"
      source "dell-omsa-repository.repo.erb"
      notifies :run, resources(:execute => "yum -q makecache"), :immediately
    end

    package "srvadmin-all" do
      action :install
    end

    if node[:repo][:dell][:install_optional]
      template "/etc/yum.repos.d/dell-community-repository.repo" do
        mode "0644"
        source "dell-community-repository.repo.erb"
        # Not installing anything in this recipe right now, so I left out
        # the yum makecache command to speed things up.
      end

      template "/etc/yum.repos.d/dell-firmware-repository.repo" do
        mode "0644"
        source "dell-firmware-repository.repo.erb"
        notifies :run, resources(:execute => "yum -q makecache"), :immediately
        notifies(:create, resources('ruby_block[reload-yum-cache]'), :immediately)
      end

      package "firmware-tools" do
        action :install
      end
      # yum install $(bootstrap_firmware) at your own risk
    end

  end
end
