#!/bin/bash

docker run -itd -p3306:3306 -v/tmp:/tmp/ttt -v/opt/bin:/opt/bin -v/opt/mysql10.5:/var/lib/mysql xyzj/luwak-common:latest /root/bin/runmariadb.sh