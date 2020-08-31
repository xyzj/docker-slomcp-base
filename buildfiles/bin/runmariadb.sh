#!/bin/bash

echo "Starting mysql"
chown -R mysql:mysql /var/lib/mysql
#rm -f /var/lib/mysql/ib_log*

start-stop-daemon --start --name mysqld --background --exec /usr/sbin/mysqld -- --defaults-file=/opt/mariadb/my.cnf

sleep 5

mysql -uroot -plp1234xy -D mysql -e "set global table_open_cache=1048576;"

/bin/bash