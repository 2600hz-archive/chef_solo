# Cookbook Name:: erlang
# Recipe:: default
# Author:: Joe Williams <joe@joetify.com>
#
# Copyright 2008-2009, Joe Williams
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
packages = value_for_platform(
        [ "centos", "redhat", "fedora", "suse" ] => {
          "default" => %w(unixODBC-devel tk)
        },
        [ "ubuntu", "debian"] => {
          "default" => %w( unixODBC-dev)
        }
)

case node[:platform]
when "debian", "ubuntu"
  packages.each do |pkg|
        yum_package pkg do
          action :install
          arch "x86_64"
        end
  end
  erlpkg = node[:erlang][:gui_tools] ? "erlang" : "erlang-nox"
  package erlpkg
  package "erlang-dev"
when "centos", "redhat", "fedora"
  packages.each do |pkg|
        yum_package pkg do
          action :install
          arch "x86_64"
        end
  end
  package "esl-erlang"
when "amazon"
  package "esl-erlang"
end
