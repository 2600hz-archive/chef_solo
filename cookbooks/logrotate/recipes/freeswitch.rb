#
# Cookbook Name:: logrotate
# Recipe:: freeswitch
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

logrotate_app "freeswitch" do
  paths "/var/log/freeswitch/*.log"
  rotate 20
  size "10M"
end

cron "logrotate freeswitch hourly by cron" do
  command "/usr/sbin/logrotate -f /etc/logrotate.d/freeswitch"
  minute "10"
end
