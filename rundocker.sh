#!/bin/bash

docker run -ti -p80:80 -p443:443 -p 8443:8443 -p 2377-2380:2377-2380 -p 5671-5672:5671-5672 -p 15672:15672 -p 6379:6379 -p3306:3306 -v /tmp:/tmp/ttt -v /home/xy/luwak/mysql:/var/lib/mysql -v /home/xy/Downloads/html/:/opt/html -v /home/xy/luwak/luwak-service/buildfiles/nginx/sites-enabled/:/etc/nginx/sites-enabled xyzj/luwak-service:latest
