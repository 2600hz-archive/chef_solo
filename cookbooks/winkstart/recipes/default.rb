#
# Cookbook Name:: winkstart
# Recipe:: default
#
# Copyright 2012, 2600hz
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

include_recipe "apache2::winkstart"

%w{winkstart winkstart-cluster winkstart-connect winkstart-dashboard winkstart-indesign winkstart-phone winkstart-provision winkstart-userportal }.each do |pkg|
	yum_package "#{pkg}" do 
		action :upgrade
	end
end
