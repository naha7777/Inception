#!/bin/bash

# wait for mariadb
until mysql -h mariadb -u"$SQL_USER" -p"$SQL_PASSWORD" "$SQL_DATABASE" -e "SELECT 1" >/dev/null 2>&1; do
    sleep 2
done

# recreate the web site directory just in case, and go in it
mkdir -p /var/www/html
cd /var/www/html

# If it's the first launch, the volume is empty and we must install everything
if [ ! -f wp-config.php ]; then
	# Download WordPress files on the web site directory
	wp core download --allow-root --path=/var/www/html
	# Generate wp-config.php with connection informations
	wp config create --allow-root \
		--dbname="$SQL_DATABASE" \
		--dbuser="$SQL_USER" \
		--dbpass="$SQL_PASSWORD" \
		--dbhost=mariadb:3306 \
		--path=/var/www/html

	# Cebsite and admin setup
	wp core install --allow-root \
		--url="$DOMAIN_NAME" \
		--title="$SITE_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--path=/var/www/html

	# Create a second user
	wp user create --allow-root \
		"$WP_USER" "$WP_USER_EMAIL" \
		--user_pass="$WP_USER_PASSWORD" \
		--role=author \
		--path=/var/www/html
	
	# Give files to the user
	chown -R www-data:www-data /var/www/html
fi

# Keep php-fpm on PID 1
exec /usr/sbin/php-fpm8.2 -F
