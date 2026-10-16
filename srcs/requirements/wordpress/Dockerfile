FROM		debian:bookworm

RUN			apt-get update -y && apt-get upgrade -y
RUN			apt-get -y install wget
# Install PHP language
RUN			apt-get install -y php8.2\
			# PHP process manager, which receives requests from Nginx
			php-fpm\
			# Allows PHP to talk to MariaDB
			php-mysql\
			php-curl\
			php-gd\
			php-intl\
			php-mbstring\
			php-soap\
			php-xml\
			php-zip\
			curl\
			# Provides mysqladmin
			mariadb-client

# change php-fpm config
RUN			sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf \
			&& echo "clear_env = no" >> /etc/php/8.2/fpm/pool.d/www.conf
RUN			mkdir -p /run/php

# Download WP-CLI, make it executable
RUN			wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN			chmod +x wp-cli.phar
RUN			mv wp-cli.phar /usr/local/bin/wp

# Copy script on the docker image to make it executable
COPY		conf/auto_config.sh /usr/local/bin/auto_config.sh
RUN			chmod +x /usr/local/bin/auto_config.sh

EXPOSE		9000

# Launch the script and php-fpm become PID 1
ENTRYPOINT	["/usr/local/bin/auto_config.sh"]
