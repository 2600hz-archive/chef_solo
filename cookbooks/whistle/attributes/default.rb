set[:couchdb_port] = 5984
set[:whistle][:whistle_apps_dir] = "/opt/whistle/whistle/whistle_apps"
set[:whistle][:whistle_erl_dir] = "/opt/whistle/whistle/ecallmgr"
set[:whistle][:whistle_git_url] = "git@source.2600hz.org:whistle.git"
set[:whistle][:default_apps] = "sysconf, notify, cdr, conference, stepswitch, callflow, crossbar, media_mgr, hangups, registrar"
set[:whistle][:homedir] = "/opt/whistle"

# attribs for user
set[:bigcouch][:erlang][:cookie] = "W41stl3@mqP"

set['haproxy']['admin_member_port'] = "5986"
set['haproxy']['admin_proxy_port'] = "15986"
set["haproxy"]["proxy_port"] = "15984"
set["haproxy"]["member_port"] = "5984"
