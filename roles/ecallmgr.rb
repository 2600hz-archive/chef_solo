name "ecallmgr"
description "Role for monitoring an eCallMgr node"
run_list "recipe[chef-monitor::default]", "recipe[chef-monitor::base_checks]", "recipe[chef-monitor::ecallmgr]", "recipe[chef-monitor::rabbitmq]"
