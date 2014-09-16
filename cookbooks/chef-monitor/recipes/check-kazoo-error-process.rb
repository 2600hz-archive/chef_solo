#
# Cookbook Name:: monitor
# Recipe:: check-kazoo-error-process
#
# Copyright 2014, 2600Hz inc.
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

include_recipe "monitor::default"

cookbook_file "/etc/sensu/plugins/check-log.rb" do
  source "plugins/check-log.rb"
  mode 0755
end

sensu_check "check-kazoo-error-process" do
  command "sudo /opt/sensu/embedded/bin/ruby /etc/sensu/plugins/check-log.rb --log-file /var/log/2600hz-platform.log --pattern 'Error in process' --icase -w 1 -c 1"
  handlers ["default"]
  standalone true
  interval 60
  additional(:notification => "String 'Error in process' was found in the Kazoo logs")
end
