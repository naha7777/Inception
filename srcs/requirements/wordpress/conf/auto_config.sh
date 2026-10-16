#!/bin/bash

# wait for mariadb
until mysqladmin ping -h mariadb -u"$SQL_USER" -p"$SQL_PASSWORD" --silent; do
	sleep 2
done

# directory for php-fpm
mkdir -p /var/www/html
cd /var/www/html

if [ ! -f wp-config.php ]; then
	wp core download --allow-root --path=/var/www/html
	# wp-config.php
	wp config create --allow-root \
		--dbname=$SQL_DATABASE \
		--dbuser=$SQL_USER \
		--dbpass=$SQL_PASSWORD \
		--dbhost=mariadb:3306 \
		--path=/var/www/html

	# website setup and first user (admin)
	wp core install --allow-root \
		--url=$DOMAIN_NAME \
		--title="$SITE_TITLE" \
		--admin_user=$WP_ADMIN_USER \
		--admin_password=$WP_ADMIN_PASSWORD \
		--admin_email=$WP_ADMIN_EMAIL \
		--path=/var/www/html

	# second user
	wp user create --allow-root \
		$WP_USER $WP_USER_EMAIL \
		--user_pass=$WP_USER_PASSWORD \
		--role=author \
		--path=/var/www/html

	chown -R www-data:www-data /var/www/html
fi

exec /usr/sbin/php-fpm8.2 -F
