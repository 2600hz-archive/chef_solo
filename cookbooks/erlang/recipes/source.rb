# Cookbook Name:: erlang
# Recipe:: source
# Author:: Stephen Lum <stephen@2600hz.com>
#
# Copyright 2011, 2600hz, Inc.
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

erlang_tar_gz = File.join(Chef::Config[:file_cache_path], "/", "otp_src_#{node[:erlang][:src_version]}.tar.gz")
compile_flags = "--with-ssl=/usr/include/openssl/"
case node[:platform]
when "debian", "ubuntu"
  package "libncurses5-dev"
  package "libssl-dev"
when "centos", "redhat", "fedora"
  package "openssl-devel"
  package "ncurses-devel"
end

cookbook_file "#{Chef::Config[:file_cache_path]}/otp_src_R14B01.tar.gz" do
	source "otp_src_R14B01.tar.gz"
	mode "0644"
end

#remote_file erlang_tar_gz do
#  checksum node[:erlang][:src_checksum]
#  source node[:erlang][:src_mirror]
#end

bash "install erlang #{node[:erlang][:src_version]}" do
  not_if { ::FileTest.exists?("/usr/local/bin/erl") }
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf #{erlang_tar_gz}
    cd otp_src_#{node[:erlang][:src_version]} && ./configure #{compile_flags} && make && make install
  EOH
end
