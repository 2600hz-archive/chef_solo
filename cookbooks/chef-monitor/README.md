Description
===========

Monitor is a cookbook for monitoring services, using Sensu, a
monitoring framework. The default recipe installs & configures the
Sensu client (monitoring agent), as well as common service check
dependencies. The master recipe installs & configures the Sensu server,
API, dashboard, & their dependencies (eg. RabbitMQ & Redis). The
remaining recipes are intended to put monitoring checks in place in
order to monitor specific services (eg. `recipe[monitor::redis]`).

Learn more about Sensu [Here](https://github.com/sensu/sensu/wiki).

Requirements
============

The [Sensu cookbook](http://community.opscode.com/cookbooks/sensu).

Attributes
==========

`node["monitor"]["environment_aware_search"]` - Defaults to false.
If true, will limit search to the node's chef_environment.

`node["monitor"]["use_private_ipv4"]` - Defaults to false. If true,
use cloud local\_ipv4 when available instead of public\_ipv4.

`node["monitor"]["additional_client_attributes"]` - Additional client
attributes to be passed to the sensu_client LWRP.

`node["monitor"]["sensu_plugin_version"]` - Sensu Plugin library
version.

`node["monitor"]["default_handlers"]` - Default event handlers.

`node["monitor"]["metric_handlers"]` - Metric event handlers.

Usage
=====

Example: To monitor the Redis service running on a Chef node, include
"recipe[monitor::redis]" in its run list.
