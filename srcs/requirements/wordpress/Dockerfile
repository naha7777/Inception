FROM	debian:bookworm

# install wget and php
RUN		apt-get update -y && apt-get upgrade -y
RUN		apt-get -y install wget
RUN		apt-get install -y php7 .3\
		php-fpm\
		php-mysql\
		mariadb-client
# install wordpress thanks to wget
RUN		wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www
# unzip wordpress
RUN		cd /var/www && tar -xzf wordpress-6.0-fr_FR.tar.gz \
		&& rm wordpress-6.0-fr_FR.tar.gz
# give permissions to root
RUN		chown -R root:root /var/www/wordpress
