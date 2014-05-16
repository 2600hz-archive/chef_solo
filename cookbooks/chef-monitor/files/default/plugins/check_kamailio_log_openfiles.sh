#!/bin/bash

tail -n 100 /var/log/kamailio/kamailio.log | grep "Too many open files" &>/dev/null

if [ $? -eq 0 ]
then
  exit 2
else
  exit 0
fi
