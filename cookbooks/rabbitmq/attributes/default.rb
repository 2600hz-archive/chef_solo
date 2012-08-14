default[:rabbitmq][:nodename]  = "rabbit"
default[:rabbitmq][:config] = nil
set_unless[:rabbitmq][:address]  = "0.0.0.0"
set_unless[:rabbitmq][:port]  = "5672"
set_unless[:rabbitmq][:logdir] = "/var/log/rabbitmq"
set_unless[:rabbitmq][:mnesiadir] = "/var/lib/rabbitmq/mnesia"
#clustering
default[:rabbitmq][:cluster_config] = "/etc/rabbitmq/rabbitmq_cluster.config"
default[:rabbitmq][:cluster_disk_nodes] = []
set_unless[:rabbitmq][:cluster] = "yes"
