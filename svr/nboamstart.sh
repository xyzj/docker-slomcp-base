#!/bin/bash

start-stop-daemon --start --name uas --background -d /root/svr/bin --exec /root/svr/bin/nboam -- -conf=../conf/nbiotmanager.conf -http=10003
