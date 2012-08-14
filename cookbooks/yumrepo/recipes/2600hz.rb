#
# Cookbook Name:: yumrepo
# Recipe:: 2600hz
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

case node[:platform] when "redhat","centos","amazon"
  if node[:platform_version].to_f >= 5 and node[:repo][:epel][:enabled]

    execute "yum -q makecache" do
      action :nothing
    end

    ruby_block("reload-yum-cache") do
      block do
        Chef::Provider::Package::Yum::YumCache.instance.reload
      end
    end


    template "/etc/yum.repos.d/2600hz.repo" do
      mode "0644"
      source "2600hz.repo.erb"
      notifies :run, resources(:execute => "yum -q makecache"), :immediately
      notifies :create, resources('ruby_block[reload-yum-cache]'), :immediately
      not_if "grep 'falafel shop' /etc/yum.repos.d/2600hz.repo"
    end

  end
end
