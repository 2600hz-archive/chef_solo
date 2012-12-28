#
# Cookbook Name:: yum
# Attributes:: 2600hz
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

case node['platform']
when "amazon"
  default['yum']['2600hz_custom']['url'] = "http://rpm.2600hz.com/$releasever/$basearch"
  default['yum']['2600hz_packages']['url'] = "http://packages.2600hz.com/rpm/$releasever/$basearch"
else
  default['yum']['2600hz_custom']['url'] = "http://rpm.2600hz.com/$releasever/$basearch"
  default['yum']['2600hz_packages']['url'] = "http://packages.2600hz.com/rpm/$releasever/$basearch"
end