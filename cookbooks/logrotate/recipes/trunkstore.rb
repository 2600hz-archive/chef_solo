#
# Cookbook Name:: logrotate
# Recipe:: trunkstore
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

include_recipe "logrotate"

logrotate_app "2600hz-platform" do
  paths "/var/log/2600hz-platform.log"
  rotate 96
  size "50M"
end

logrotate_app "2600hz-amqp" do
	paths "/var/log/2600hz-amqp.log"
	rotate 96
	size "50M"
end

cron "logrotate 2600hz-platform hourly by cron" do
  command "/usr/sbin/logrotate -f /etc/logrotate.d/2600hz-platform"
  minute "10"
end

cron "logrotate 2600hz-amqp.log hourly by cron" do
	command "/usr/sbin/logrotate -f /etc/logrotate.d/2600hz-amqp"
	minute "30"
end