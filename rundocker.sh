#!/bin/bash

docker run -itd -p 2377-2380:2377-2380 -p 5671-5672:5671-5672 -p 15672:15672 -p 6379:6379 -p3306:3306 -v /tmp:/tmp/ttt -v /opt/mysql10.5:/var/lib/mysql xyzj/luwak-common:latest
