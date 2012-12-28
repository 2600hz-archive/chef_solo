# chef-solo-search

Chef-solo-search is a cookbook library that adds data bag search powers
to Chef Solo. Data bag support was added to Chef Solo by Chef 0.10.4.
Please see *Supported queries* for a list of query types which are supported.

## Requirements

    * ruby >= 1.8
    * ruby-chef >= 0.10.4

## Installation

In order to use this extension, create a (dummy-) cookbook and add a directory
called *libraries*. Next copy *libraries/search.rb* and *libraries/parser.rb* to the newly created directory.
Now you have to make sure chef-solo knows about data bags, therefore add

    data_bag_path "<node_work_path>/data_bags"

to the config file of chef-solo (defaults to /etc/chef/solo.rb).

The same for your roles, add

    role_path "<node_work_path>/roles"

## Supported queries

The search methods supports a basic sub-set of the lucene query language.
Sample supported queries are:

### General queries:

    search(:users, "*:*")
    search(:users)
    search(:users, nil)
        getting all items in ':users'
    search(:users, "username:*")
    search(:users, "username:[* TO *]")
        getting all items from ':users' which have a 'username' attribute
    search(:users, "(NOT username:*)")
    search(:users, "(NOT username:[* TO *])")
        getting all items from ':users' which don't have a 'username' attribute

### Queries on attributes with string values:

    search(:users, "username:speedy")
        getting all items from ':users' with username equals 'speedy'
    search(:users, "NOT username:speedy")
        getting all items from ':users' with username is unequal to 'speedy'
    search(:users, "username:spe*")
        getting all items which 'username'-value begins with 'spe'

### Queries on attributes with array values:

    search(:users, "children:tom")
        getting all items which 'children' attribute contains 'tom'
    search(:users, "children:t*")
        getting all items which have at least one element in 'children'
        which starts with 't'

### Queries on attributes with boolean values:

    search(:users, "married:true")

### Queries in attributes with integer values:

    search(:users, "age:35")

### OR conditions in queries:

    search(:users, "age:42 OR age:22")

### AND conditions in queries:

    search(:users, "married:true AND age:35")

### NOT condition in queries:

    search(:users, "children:tom NOT gender:female")

### More complex queries:

    search(:users, "children:tom NOT gender:female AND age:42")


## Supported Objects
The search methods have support for 'roles', 'nodes' and 'databags'.

### Roles
You can use the standard role objects in json form and put them into your role path

    {
      "name": "monitoring",
      "default_attributes": { },
      "override_attributes": { },
      "json_class": "Chef::Role",
      "description": "This is just a monitoring role, no big deal.",
          "run_list": [
          ],
      "chef_type": "role"


### Nodes
Nodes are injected through a databag called 'node'.  Create a databag called 'node' and put your json files there
You can use the standard node objects in json form.

    {
      "id": "vagrant",
      "name": "vagrant-vm",
      "chef_environment": "_default",
      "json_class": "Chef::Node",
      "automatic": {
        "hostname": "vagrant.vm",
        "os": "centos"
      },
      "normal": {
      },
      "chef_type": "node",
      "default": {
      },
      "override": {
      },
      "run_list": [
        "role[monitoring]"
      ]
    }

### Databags
You can use the standard databag objects in json form

    {
      "id": "my-ssh",
      "hostgroup_name": "all",
      "command_line": "$USER1$/check_ssh $HOSTADDRESS$"
    }

## Running tests

Running tests is as simple as:

    % ruby -Ilibraries tests/test_search.rb -v
