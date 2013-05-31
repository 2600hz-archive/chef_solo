#
# Cookbook Name:: bigcouch
# Recipe:: default
#
# Copyright 2011, Cloudant
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

Chef::Log.info("##############################################");
Chef::Log.info("## Installing BigCouch RPM and Dependencies ##");
Chef::Log.info("## (Includes SpiderMonkey and OpenSSL)      ##");
Chef::Log.info("##############################################");

include_recipe "libicu::default"
include_recipe "spidermonkey::default"
include_recipe "bluepill"

curl_tar_gz = File.join(Chef::Config[:file_cache_path], "/", "curl-#{node[:curl][:src_version]}.tar.gz")

case node[:platform]
when "ubuntu"
  
  include_recipe "runit"
  
  if node[:kernel][:machine] == "x86_64"
    build = "amd64"
  elsif node[:kernel][:machine] = "i686" || node[:kernel][:machine] == "i386"
    build = "i386"
  end
  
  package = "deb"
  filename = "bigcouch_#{node[:bigcouch][:version]}_#{build}.#{package}"
  
when "centos","redhat","amazon"
  
  %w{openssl openssl-devel}.each do |pkg|
    package pkg
  end
end

case node[:platform]
when "ubuntu"
  dpkg_package(bigcouch_pkg_path) do
    source bigcouch_pkg_path
    action :install
    not_if "/usr/bin/test -d /opt/bigcouch"
  end

when "centos","redhat","amazon"
  package "bigcouch" do
    action :upgrade
    options "--enablerepo=epel"
  end

  template "/etc/init.d/bigcouch" do
    source "bigcouch-init.d-script.erb"
    mode "0755"
  end

  bluepill_service "bigcouch" do
    supports :restart => true, :stop => true, :start => true
    action :start
  end

end

directory node[:bigcouch][:database_dir] do
  owner "bigcouch"
  group "bigcouch"
  mode "0755"
end
 
directory node[:bigcouch][:view_index_dir] do
  owner "bigcouch"
  group "bigcouch"
  mode "0755"
end
 
template "/opt/bigcouch/etc/local.ini" do
  source "local_ini.erb"
  owner "bigcouch"
  group "bigcouch"
  mode 0644
  notifies :restart, resources(:service => "bigcouch"), :immediately
end

template "/etc/security/limits.d/bigcouch.limits.conf" do
  source "bigcouch.limits.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "bigcouch")
end

template "/opt/bigcouch/etc/vm.args" do
  source "vm_args.erb"
  owner "bigcouch"
  group "bigcouch"
  mode 0644
  notifies :restart, resources(:service => "bigcouch")
end

template "/etc/bluepill/bigcouch.pill" do
  source "bigcouch.pill.erb"
end

bluepill_service "bigcouch" do
  action [:load]
end

%w{db view_index}.each do |dir|
  execute "chown -R bigcouch:bigcouch /srv/#{dir}"
end

case node[:platform]
when "ubuntu"
  runit_service "bigcouch"
end

Chef::Log.info("##############################");
Chef::Log.info("## Done Installing BigCouch ##");
Chef::Log.info("##############################");
