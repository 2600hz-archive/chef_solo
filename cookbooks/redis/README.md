# DESCRIPTION:

Installs and configures [Redis](http://redis.io/).

** NOTE **
This cookbook does not currently configure or manage Redis replication.

# REQUIREMENTS:

The Redis cookbook has been tested on Ubuntu 10.04, 11.04, 11.10, 12.04, Debian 6.0, and CentOS 5 and 6.

## Cookbooks:

* [yum](https://github.com/opscode-cookbooks/yum) - Used to install Redis package from EPEL repo on CentOS/Redhat.
* [build-essential](https://github.com/opscode-cookbooks/build-essential) - Used when compiling Redis.
* [runit](https://github.com/opscode-cookbooks/runit) - Used only if Redis is configured to start with Runit.

# ATTRIBUTES:

## Installation:
* `['redis']['install_type']` - Install the Package by default. [ package, source ]
* `['redis']['source']['sha']` - The sha256 checksum of the source tarball.
* `['redis']['source']['url']` - The url to the source tarball.
* `['redis']['source']['version']` - The version of Redis to install.
* `['redis']['src_dir']` - Extract the Redis source to this directory.
* `['redis']['dst_dir']` - Install compiled Redis to this directory.
* `['redis']['conf_dir']` - The Redis configuration directory.
* `['redis']['init_style']` - A value of "init" is currently recommended, but full runit support is coming soon.

## Configuration:

The config file template should support all current configuration options. If we've missed something please file a ticket.

* `['redis']['config']['appendonly']` - Use the AOF file writing system.
* `['redis']['config']['appendfsync']` - The mode Redis uses for fsync() calls. [ everysec, no, always ]
* `['redis']['config']['daemonize']` - Run Redis as a daemon. In this mode Redis _will_ create a pid file.
* `['redis']['config']['databases']` - Set the number of Redis databases.
* `['redis']['config']['dbfilename']` - The filename where the database is dumped.
* `['redis']['config']['dir']` - The directory where Redis will store its DB and AOF files.
* `['redis']['config']['listen_addr']` - Address to listen on. Defaults to localhost.
* `['redis']['config']['listen_port']` - Port to listen on.
* `['redis']['config']['logfile']` - The Redis logfile.
* `['redis']['config']['loglevel']` - Changes logging verbosity. [debug, verbose, notice, warning ]
* `['redis']['config']['pidfile']` - When daemonize is enabled this configures where Redis will write the pid file.
* `['redis']['config']['rdbcompression']` - Whether or not to use LZF compression when dumping .rdb databases. [ yes, no ]
* `['redis']['config']['timeout']` - Configures when Redis will timeout a idle client connection.
* `['redis']['config']['vm']['enabled']`- Use Redis' virtual memory.
* `['redis']['config']['vm']['max_memory']` - Limits the amount of memory available to Redis.
* `['redis']['config']['vm']['max_threads']` - Maximum number of VM I/O threads running simultaneously.
* `['redis']['config']['vm']['page_size']` - Configures the page size Redis uses when writing out swap files.
* `['redis']['config']['vm']['pages']` - The total number of memory pages in a swap file.
* `['redis']['config']['vm']['vm_swap_file']` - The Redis swapfile.

** The following configuration settings are only available in redis >= 2.1.12 -- http://redis.io/commands/slowlog **

* `['redis']['config']['configure_slowlog']` - Adds or Removes slowlog options from your redis.conf [ true, nil ]
* `['redis']['config']['slowlog_log_slower_than']` - Time in microseconds a command must run beyond to be caught by the slow logger.
* `['redis']['config']['slowlog_max_len']` - The length of the slow log.

** The following configuration settings are only available in newer versions of Redis. Exact version is not known, other than
   these will fail on the Redis 1.2.x distro package included with older Ubuntu and Debian 6.

* `default['redis']['config']['configure_maxmemory_samples']` - Adds or removes maxmemory-samples options from your redis.conf [ true, nil ]
* `default['redis']['config']['maxmemory_samples']` - Number of keys redis will sample when checking the LRU for keys to evict.

* `default['redis']['config']['configure_no_appendfsync_on_rewrite']` - Adds or removes no-appendfsync-on-rewrite options from your redis.conf [ true, nil ]
* `default['redis']['config']['no_appendfsync_on_rewrite']` - [ yes, no ]

* `default['redis']['config']['configure_list_max_ziplist']` - Adds or removes list-max-ziplist-* options from your redis.conf [ true, nil ]
* `default['redis']['config']['list_max_ziplist_entries']` - Encode small lists in a special way if they are under this limit
* `default['redis']['config']['list_max_ziplist_value']` - Encode small lists in a special way if they are under this limit

* `default['redis']['config']['configure_set_max_intset_entries']` - Adds or removes set-max-intset-entries options from your redis.conf [ true, nil ]
* `default['redis']['config']['set_max_intset_entries']` - Use special encoding of sets of strings if the set is smaller than this limit

# USAGE:

There are several recipes broken up into reusable pieces. For ease of use, we've also included wrappers that map the most common use.

* `redis::_group` - Creates a group for Redis.
* `redis::_server_config` - Creates configuration directories and installs templatized redis.conf.
* `redis::_server_init` - Installs a templatized Redis sysv initscript.
* `redis::_server_install_from_package` - Installs Redis through the chef package resource.
* `redis::_server_install_from_package` - Downloads, compiles, and installs Redis from source.
* `redis::_server_runit` - Installs templatized Redis runit configuration.
* `redis::_server_service` - Configures Redis through the chef service resource.
* `redis::_user` - Creates a user for Redis.
* `redis::default` - The default recipe executes the redis::server_package recipe.
* `redis::server` - The default recipe executes the redis::server_package recipe. This recipe is here for compatibility with other community Redis cookbooks.
* `redis::server_package` - Uses the recipe crumbs in the Redis cookbook to manage a packaged Redis instance.
* `redis::server_source` - Uses the recipe crumbs in the Redis cookbook to manage a source compiled Redis instance.

# CONTRIBUTE:

Please feel free to add issues, and submit pull requests to our [github](https://github.com/CXInc/chef-redis)!

# LICENSE & AUTHOR:
Author:: Miah Johnson (<miah@cx.com>)
Copyright:: 2012, CX, Inc
Author:: Noah Kantrowitz (<nkantrowitz@crypticstudios.com>)
Copyright:: 2010, Atari, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
