#
# Cookbook Name:: monitor
# Recipe:: check_kamailio_log_openfiles
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

cookbook_file "/etc/sensu/plugins/check_kamailio_log_openfiles.sh" do
  source "plugins/check_kamailio_log_openfiles.sh"
  mode 0755
end

sensu_check "check_kamailio_log_openfiles" do
  command "check_kamailio_log_openfiles.sh"
  handlers ["default"]
  standalone true
  interval 30
  additional(:notification => "Kamailio cannot open new connections as its open files limits were reached")
end

