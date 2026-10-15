#!/bin/bash

service mariadb start

until mysqladmin ping --silent; do
    sleep 1
done

# create the data table
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
# create an user
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
# give all permissions to the user
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"
# change root user
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
# refresh
mysql -e "FLUSH PRIVILEGES;"
#restart
mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

exec mysqld_safe
