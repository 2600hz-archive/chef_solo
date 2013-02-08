#
# Author:: Stephen Lum (<stephen@2600hz.com>)
# Cookbook Name:: yum
# Recipe:: 2600hz
#
# Copyright:: Copyright (c) 2012 2600hz, Inc.
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

yum_repository "2600hz_custom" do
  description "2600hz Custom Repo"
  url node['yum']['2600hz_custom']['url']
  action platform?('amazon') ? [:add, :update] : :add
end

yum_repository "2600hz_packages" do
  description "2600hz Packages Repo"
  url node['yum']['2600hz_packages']['url']
  action platform?('amazon') ? [:add, :update] : :add
end
