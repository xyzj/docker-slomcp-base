FROM ubuntu:latest
MAINTAINER      X.Minamoto "xuyuan8720@189.cn"

ENV 			DEBIAN_FRONTEND noninteractive

COPY			buildfiles /root/

EXPOSE		2378-2380 5671 5672 15672 6379 3306 80 443

RUN			/bin/echo 'root:administratorishere' |chpasswd;useradd xy;/bin/echo 'xy:iamlegal' |chpasswd; \
				/usr/bin/apt-get -y update; \
				/usr/bin/apt-get -y full-upgrade; \
				/usr/bin/apt-get -y install apt-utils; \
				/usr/bin/apt-get -y autoremove; \
				/usr/bin/apt-get -y install net-tools nano tzdata ssh rabbitmq-server redis-server mariadb-server-10.1 nginx; \
				/usr/bin/apt-get -y clean; \
				/usr/bin/apt-get -y autoclean; \
				 \
				rm -rf /tmp/*; \
				ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
				echo "Asia/Shanghai" > /etc/timezone; \
				dpkg-reconfigure -f noninteractive tzdata; \
				/bin/echo "requirepass arbalest" >> /etc/redis/redis.conf; \
				sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mariadb.conf.d/50-server.cnf; \
				/bin/echo "net.ipv4.ip_forward=1">>/etc/sysctl.conf; \
				/bin/echo 'Port 10022' >> /etc/ssh/sshd_config; \
				/bin/echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config; \
				sed -i "s/bind 127.0.0.1 ::1/bind 0.0.0.0/g" /etc/redis/redis.conf; \
				cp -f /root/rmq/rabbitmq.config /etc/rabbitmq/rabbitmq.config; \
				/bin/echo 'alias rmqctl=rabbitmqctl'>> /root/.bashrc; \
				/bin/echo 'export PATH=$PATH:/root/svr'>> /root/.bashrc; \
				/bin/echo 'export PATH=$PATH:/root/svr/bin'>> /root/.bashrc; \
				chown -R root:root /root; \
				service rabbitmq-server restart; \
				rabbitmq-plugins enable rabbitmq_management

# CMD			/usr/sbin/sshd -D

# ENTRYPOINT	["/root/run.sh"]
