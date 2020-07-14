#!/bin/bash

docker run -dti  --privileged --restart=on-failure -p 80:80 -p 443:443 -p 2378-2380:2378-2380 -p 5671-5672:5671-5672 -p 15672:15672 -p 6379:6379 -p3306:3306 -v /opt/mysql:/var/lib/mysql -v /home/xy/luwak/svr:/root/svr xyzj/luwak-service:latest
