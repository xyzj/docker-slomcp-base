#!/bin/bash

pkill -9 -f etcd

echo "Starting rabbitmq"
#start-stop-daemon --start --name rabbitmq-server --pidfile /var/run/rabbitmq/pid --background --exec /usr/sbin/rabbitmq-server
service rabbitmq-server restart

chown -R mysql:mysql /var/lib/mysql
rm -f /var/lib/mysql/ib_log*

service ssh restart
sleep 1

sed -i "s/# requirepass foobared/requirepass arbalest/g" /etc/redis/redis.conf
service redis-server restart
sleep 1

echo "Starting mysql"
# service mysql start
start-stop-daemon --start --name mysqld --background --exec /usr/sbin/mysqld -- --defaults-file=/opt/mariadb/my.cnf
#start-stop-daemon --start --name mysqld --background --exec /usr/sbin/mysqld -- --bind-address=0.0.0.0 --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/x86_64-linux-gnu/mariadb18/plugin --user=mysql --skip-log-error --pid-file=/tmp/mysqld.pid --socket=/var/lib/mysql/mysqld.sock --port=3306
sleep 1

echo "Starting etcd"
start-stop-daemon --start --name etcd --background -d /opt/etcd --exec /opt/etcd/etcd -- -name luwak --data-dir /opt/etcd/luwak.etcd --cert-file=/opt/ca/server.pem --key-file=/opt/ca/server-key.pem --advertise-client-urls=https://0.0.0.0:2378,http://0.0.0.0:2379 --listen-client-urls=https://0.0.0.0:2378,http://0.0.0.0:2379
sleep 2

#service rabbitmq-server start
rabbitmqctl add_user arx7 arbalest
rabbitmqctl set_user_tags arx7 administrator
rabbitmqctl set_permissions -p / arx7 ".*" ".*" ".*"

/bin/bash