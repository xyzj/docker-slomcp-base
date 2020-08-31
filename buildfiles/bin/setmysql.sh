#!/bin/bash

mysqladmin -uroot password lp1234xy

mysql -uroot -plp1234xy -D mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'lp1234xy' WITH GRANT OPTION;GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY 'lp1234xy' WITH GRANT OPTION;GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'lp1234xy' WITH GRANT OPTION;FLUSH PRIVILEGES;"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mariadb.conf.d/50-server.cnf

