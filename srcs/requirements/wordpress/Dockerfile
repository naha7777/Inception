FROM		debian:bookworm

# install wget and php
RUN			apt-get update -y && apt-get upgrade -y
RUN			apt-get -y install wget
RUN			apt-get install -y php8.2\
			php-fpm\
			php-mysql\
			php-curl\
			php-gd\
			php-intl\
			php-mbstring\
			php-soap\
			php-xml\
			php-zip\
			curl\
			mariadb-client

# change php-fpm config
RUN			sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf \
			&& echo "clear_env = no" >> /etc/php/8.2/fpm/pool.d/www.conf
RUN			mkdir -p /run/php
# WP-CLI
RUN			wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN			chmod +x wp-cli.phar
RUN			mv wp-cli.phar /usr/local/bin/wp

COPY		conf/auto_config.sh /usr/local/bin/auto_config.sh
RUN			chmod +x /usr/local/bin/auto_config.sh

EXPOSE		9000

ENTRYPOINT	["/usr/local/bin/auto_config.sh"]
