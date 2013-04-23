#!/bin/bash

E_SUCCESS="0"
E_WARNING="1"
E_CRITICAL="2"
E_UNKNOWN="3"

erlangListener=`/usr/bin/fs_cli -x 'erlang listeners' |cut -d ' ' -f3 |cut -d '@' -f2 |grep -v "^[[:blank:]]*$"`
line=`/usr/bin/fs_cli -x 'erlang listeners' |cut -d ' ' -f3 |cut -d '@' -f2 |grep -v "^[[:blank:]]*$" |wc -l`

if [ "$line" -gt "1" ];
        then

        echo "$line ecallmgr  are currently connected:" $erlangListener
        exit ${E_SUCCESS}

elif [ "$line" = "1" ];
        then

        echo "Just one ecallmgr connected: $erlangListener"
        exit ${E_WARNING}

else
        echo "0 ecallmgr are connected to this FreeSWITCH!"
        exit ${E_CRITICAL}

fi