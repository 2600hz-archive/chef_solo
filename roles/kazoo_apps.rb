name "kazoo_apps"
description "Role for monitoring a Kazoo Apps node"
run_list "recipe[chef-monitor::default]", "recipe[chef-monitor::base_checks]", "recipe[chef-monitor::kazoo_apps]", "recipe[chef-monitor::rabbitmq]"
