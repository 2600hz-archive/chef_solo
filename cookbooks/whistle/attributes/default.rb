set[:couchdb_port] = 5984
set[:kazoo][:kazoo_apps_dir] = "/opt/kazoo/whistle_apps"
set[:kazoo][:kazoo_erl_dir] = "/opt/kazoo/ecallmgr"
set[:kazoo][:kazoo_git_url] = "git@source.2600hz.org:whistle.git"
set[:kazoo][:default_apps] = "sysconf, notify, cdr, conference, stepswitch, callflow, crossbar, media_mgr, hangups, registrar"
set[:kazoo][:homedir] = "/opt/kazoo"

# attribs for user
set[:bigcouch][:erlang][:cookie] = "W41stl3@mqP"

set['haproxy']['admin_member_port'] = "5986"
set['haproxy']['admin_proxy_port'] = "15986"
set["haproxy"]["proxy_port"] = "15984"
set["haproxy"]["member_port"] = "5984"
