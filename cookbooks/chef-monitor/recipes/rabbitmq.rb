#
# Cookbook Name:: chef-monitor
# Recipe:: rabbitmq
#
# Copyright 2013, Sean Porter Consulting
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

include_recipe "chef-monitor::_rabbitmq"

sensu_gem "rest-client"

%w[
	rabbitmq-queue-metrics.rb
	rabbitmq-alive.rb
	check-rabbitmq-messages.rb
        rabbitmq-nodes.rb
].each do |check|
	cookbook_file "/etc/sensu/plugins/#{check}" do
  	source "plugins/#{check}"
  	mode 0755
	end
end

=begin
sensu_check "rabbitmq_overview_metrics" do
  command "rabbitmq-overview-metrics.rb --scheme stats.:::name:::"
  handlers ["graphite"]
  subscribers ["kazoo"]
  standalone true
  interval 60
  type "metric"
end

sensu_check "rabbitmq-queue-metrics" do
  command "rabbitmq-queue-metrics.rb --scheme stats.:::name:::"
  handlers ["graphite"]
  subscribers ["kazoo"]
  standalone true
  interval 60
end
=end

sensu_check "rabbitmq-alive" do
  command "rabbitmq-alive.rb"
  handlers ["default"]
  standalone true
  interval 60
end

sensu_check "check-rabbitmq-messages" do
  command "check-rabbitmq-messages.rb"
  handlers ["default"]
  standalone true
  interval 60
end

sensu_check "rabbitmq-nodes" do
  command "rabbitmq-nodes.rb"
  handlers ["default"]
  standalone true
  interval 60
end
