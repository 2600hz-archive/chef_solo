name "kazoo_api"
description "Role for monitoring Kazoo API"
run_list "recipe[chef-monitor::default]", "recipe[chef-monitor::base_checks]", "recipe[chef-monitor::kazoo_api]", "recipe[chef-monitor::rabbitmq]"
