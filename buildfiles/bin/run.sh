#!/bin/bash

start-stop-daemon --stop -p /run/etcd.pid
start-stop-daemon --stop -p /run/sslrenew.pid

#start-stop-daemon --start --name rabbitmq-server --pidfile /var/run/rabbitmq/pid --background --exec /usr/sbin/rabbitmq-server
service rabbitmq-server start

chown -R mysql:mysql /var/lib/mysql
#rm -f /var/lib/mysql/ib_log*

# sslrenew start
start-stop-daemon --start -m -p /run/sslrenew.pid --background -d /opt/bin --exec /opt/bin/sslrenew
sleep 2

service ssh restart
sleep 2

sed -i "s/# requirepass foobared/requirepass arbalest/g" /etc/redis/redis.conf
service redis-server restart
sleep 2

echo "Starting mysql"
# service mysql start
start-stop-daemon --start -m -p /run/mysqld.pid --background --exec /usr/sbin/mysqld -- --defaults-file=/opt/mariadb/my.cnf
#start-stop-daemon --start --name mysqld --background --exec /usr/sbin/mysqld -- --bind-address=0.0.0.0 --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/x86_64-linux-gnu/mariadb18/plugin --user=mysql --skip-log-error --pid-file=/tmp/mysqld.pid --socket=/var/lib/mysql/mysqld.sock --port=3306
sleep 2

echo "Starting etcd"
start-stop-daemon --start -m -p /run/etcd.pid --background -d /opt/etcd --exec /opt/etcd/etcd -- -name luwak --data-dir /opt/etcd/luwak.etcd --cert-file=/opt/ca/server.pem --key-file=/opt/ca/server-key.pem --advertise-client-urls=https://0.0.0.0:2378,http://0.0.0.0:2379 --listen-client-urls=https://0.0.0.0:2378,http://0.0.0.0:2379
sleep 2

# nginx start
#service nginx stop
#sleep 1
#service nginx start
#sleep 2

echo "Starting rabbitmq"
service rabbitmq-server restart
sleep 1
rabbitmqctl add_user arx7 arbalest
rabbitmqctl set_user_tags arx7 administrator
rabbitmqctl set_permissions -p / arx7 ".*" ".*" ".*"
rabbitmqadmin declare exchange --vhost=/ name=luwak_topic type=topic durable=true auto_delete=false
sleep 2

/opt/bin/runext.sh
