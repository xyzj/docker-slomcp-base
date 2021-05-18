#!/bin/bash

docker run -itd \
    -p 2377-2380:2377-2380 \
    -p 5671-5672:5671-5672 \
    -p 15672:15672 \
    -p 6379:6379 \
    -p3306:3306 \
    -v /tmp:/tmp/ttt \
    -v /home/mysql_data:/var/lib/mysql \
    xyzj/luwak-common:latest \
    /opt/bin/run.sh

echo "The container will be ready in 30 seconds"