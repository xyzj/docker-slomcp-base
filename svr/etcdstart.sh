#!/bin/bash

start-stop-daemon --start --name etcd --background -d /root/etcd --exec /root/etcd/etcd -- --config-file=/root/etcd/etcd.conf

