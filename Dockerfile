FROM ubuntu:latest
MAINTAINER      X.Minamoto "xuyuan8720@189.cn"

ENV 			DEBIAN_FRONTEND noninteractive

COPY			buildfiles /root/

EXPOSE		2378-2380 5671 5672 15672 6379 3306 80 443

RUN	/bin/echo 'root:administratorishere' |chpasswd;useradd xy;/bin/echo 'xy:iamlegal' |chpasswd; \
	/usr/bin/apt-get -y update; \
	/usr/bin/apt-get -y full-upgrade; \
	/usr/bin/apt-get -y install apt-utils software-properties-common; \
	/usr/bin/apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8; \
	/usr/bin/add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.4/ubuntu bionic main'; \
	/usr/bin/apt-get -y update; \
	/usr/bin/apt-get -y install net-tools nano tzdata ssh rabbitmq-server redis-server mariadb-server-10.4 nginx; \
	/usr/bin/apt-get -y autoremove; \
	/usr/bin/apt-get -y clean; \
	/usr/bin/apt-get -y autoclean; \
	rm -rf /tmp/*; \
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
	echo "Asia/Shanghai" > /etc/timezone; \
	dpkg-reconfigure -f noninteractive tzdata; \
	cp -f /root/mariadb/my.cnf /etc/mysql/my.cnf

RUN	/bin/echo "requirepass arbalest" >> /etc/redis/redis.conf; \
	sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mariadb.conf.d/50-server.cnf; \
	/bin/echo "net.ipv4.ip_forward=1">>/etc/sysctl.conf; \
	/bin/echo 'Port 10022' >> /etc/ssh/sshd_config; \
	/bin/echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config; \
	sed -i "s/bind 127.0.0.1 ::1/bind 0.0.0.0/g" /etc/redis/redis.conf; \
	cp -f /root/rmq/rabbitmq.config /etc/rabbitmq/rabbitmq.config; \
	/bin/echo 'alias rmqctl=rabbitmqctl'>> /root/.bashrc; \
	/bin/echo 'export PATH=$PATH:/root/svr'>> /root/.bashrc; \
	/bin/echo 'export PATH=$PATH:/root/svr/bin'>> /root/.bashrc; \
	mkdir /var/run/mysqld; \
	chown mysql:mysql /var/run/mysqld; \
	chown -R root:root /root; \
	service rabbitmq-server restart; \
	rabbitmq-plugins enable rabbitmq_management rabbitmq_web_stomp rabbitmq_stomp

# CMD			/usr/sbin/sshd -D
WORKDIR /root
ENTRYPOINT	["/root/svr/bin/run.sh"]
