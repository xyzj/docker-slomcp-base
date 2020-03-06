#!/bin/bash

start-stop-daemon --start --name uigs --background -d /root/svr/bin --exec /root/svr/bin/uigs -- -conf=../conf/indx.conf -http=10001 -clientca=../conf/ca/rootca.pem
