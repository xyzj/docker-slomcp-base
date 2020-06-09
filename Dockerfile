FROM xyzj/luwak-lite:latest
LABEL maintainer="X.Minamoto <xuyuan8720@189.cn>"

ENV		DEBIAN_FRONTEND noninteractive

RUN	/usr/bin/apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8; \
	/usr/bin/add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.4/ubuntu bionic main'; \
	/usr/bin/apt-get -y update; \
	/usr/bin/apt-get -y install rabbitmq-server redis-server mariadb-server-10.4 nginx; \
	/usr/bin/apt-get -y autoremove; \
	/usr/bin/apt-get -y clean; \
	/usr/bin/apt-get -y autoclean; \
	rm -rf /tmp/*

COPY	buildfiles /opt/

RUN	cp -rf /opt/svr/bin /root; \
	/bin/echo "requirepass arbalest" >> /etc/redis/redis.conf; \
	cp -f /opt/mariadb/my.cnf /etc/mysql/my.cnf; \
	/bin/echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config; \
	sed -i "s/bind 127.0.0.1 ::1/bind 0.0.0.0/g" /etc/redis/redis.conf; \
	cp -f /opt/rmq/rabbitmq.config /etc/rabbitmq/rabbitmq.config; \
	/bin/echo 'alias rmqctl=rabbitmqctl'>> /root/.bashrc; \
	mkdir /var/run/mysqld; \
	chown mysql:mysql /var/run/mysqld; \
	chown -R root:root /root; \
	service rabbitmq-server restart; \
	rabbitmq-plugins enable rabbitmq_management rabbitmq_web_stomp rabbitmq_stomp
# CMD			/usr/sbin/sshd -D
ENTRYPOINT	["/root/bin/run.sh"]
