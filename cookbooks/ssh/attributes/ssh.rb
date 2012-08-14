ssh Mash.new unless attribute?(:ssh)
sshd Mash.new unless attribute?(:sshd)

default[:ssh_port] = "22223"
