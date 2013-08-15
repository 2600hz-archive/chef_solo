#!/bin/bash
 
E_SUCCESS="0"
E_WARNING="1"
E_CRITICAL="2"
E_UNKNOWN="3"
 
listenerCount=`/usr/bin/fs_cli -H 127.0.0.1 -x 'erlang nodes count'`
listenerList=`/usr/bin/fs_cli -H 127.0.0.1 -x 'erlang nodes list'`
 
if [ "$listenerCount" -gt "1" ]
then
  echo -e "$listenerCount ecallmgr are currently connected:\n$listenerList"
  exit ${E_SUCCESS}
elif [ "$listenerCount" = "1" ]
then
  echo -e "Just one ecallmgr connected:\n$listenerList"
  exit ${E_WARNING}
else
   echo "0 ecallmgr are connected to this FreeSWITCH!"
   exit ${E_CRITICAL}
fi
 
exit ${E_UNKNOWN}
