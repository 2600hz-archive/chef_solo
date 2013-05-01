#!/usr/bin/env ruby

### grabs the list of currently running whapps
whapps_running=`sudo /opt/kazoo/utils/sup/sup whapps_controller running_apps | cut -d"[" -f2 | cut -d"]" -f1`.split(',')

### grabs the list of the whapps supposed to run from the DataBase
whapps_db=`sudo /opt/kazoo/utils/sup/sup whapps_config get whapps_controller whapps | cut -d"[" -f2 | cut -d"]" -f1 | sed -e 's/<<"//g' | sed -e 's/">>//g'`.split(',')

### recreating the arrays and removing the newline characters
whapps_running.map!{|c| c.chomp }
whapps_db.map!{|c| c.chomp }

### compare the 2 arrays for missing whapps
diff = ( whapps_running - whapps_db ) | ( whapps_db - whapps_running )

if diff.empty?
  puts "OK - all Whapps are running currently"
  exit 0
elsif whapps_running.count == 0
  puts "None of the Whapps are running on this server!"
  exit 2
elsif diff
  diff.each do |x|
  puts "#{x} whapps is not running..."
  end
  exit 1
end