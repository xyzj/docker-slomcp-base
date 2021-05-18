FROM xyzj/luwak-lite:latest
LABEL maintainer="X.Minamoto"
ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8

RUN	/usr/bin/apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'; \
	/usr/bin/add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.5/ubuntu focal main'; \
	/usr/bin/apt-get -y update; \
	/usr/bin/apt-get -y upgrade; \
	/usr/bin/apt-get -y install rabbitmq-server redis-server mariadb-server-10.5; \
	/usr/bin/apt-get -y autoremove; \
	/usr/bin/apt-get -y clean; \
	/usr/bin/apt-get -y autoclean; \
	rm -rf /tmp/*

COPY	buildfiles /opt/

RUN	/bin/echo "requirepass arbalest" >> /etc/redis/redis.conf; \
	cp -f /opt/mariadb/my.cnf /etc/mysql/my.cnf; \
	sed -i "s/bind 127.0.0.1 ::1/bind 0.0.0.0/g" /etc/redis/redis.conf; \
	cp -f /opt/rmq/rabbitmq.config /etc/rabbitmq/rabbitmq.config; \
	/bin/echo 'alias rmqctl=rabbitmqctl'>> /root/.bashrc; \
	mkdir /var/run/mysqld; \
	chown mysql:mysql /var/run/mysqld; \
	service mariadb start; \
	mysql < /opt/bin/init.sql; \
	chown -R root:root /root; \
	service rabbitmq-server restart; \
	rabbitmq-plugins enable rabbitmq_management rabbitmq_web_stomp rabbitmq_stomp
# CMD			/usr/sbin/sshd -D
#ENTRYPOINT	["/opt/svr/bin/run.sh"]
