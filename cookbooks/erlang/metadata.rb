maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs erlang, optionally install GUI tools."
version           "0.8.3"

recipe "erlang", "Installs erlang"
recipe "erlang::source", "Installs erlang from source"

%w{ ubuntu debian centos }.each do |os|
  supports os
end
