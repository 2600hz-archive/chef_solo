name "ntpserver"
description "NTP role for ntp servers"
run_list()
default_attributes "ntp" => {
        "is_server" => "true",
        "servers" => [ 	"0.us.pool.ntp.org",
        		"1.us.pool.ntp.org",
        		"2.us.pool.ntp.org",
        		"3.us.pool.ntp.org"
			]
        }
