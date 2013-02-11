name             "monitor"
maintainer       "Sean Porter Consulting"
maintainer_email "portertech@gmail.com"
license          "Apache 2.0"
description      "A cookbook for monitoring services, using Sensu, a monitoring framework."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

supports "ubuntu"

depends "sensu"
