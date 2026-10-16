#!/bin/bash
# Launches MariaDB in the background
service mariadb start
# Waits for it to respond (ping)
until mysqladmin ping --silent; do
    sleep 1
done

# MariaDB create a directory for each databse. If the directory does not exist,
# it initialize it. 
if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then
    # Create the WordPress data table
    mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
    # Create a WordPress user
    mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
    # Give all permissions to the user
    mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"
    # Refresh the permissions
    mysql -e "FLUSH PRIVILEGES;"
    # Put a password to root
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
fi

# The temporary server is shut down cleanly
mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown
# Restarts the server, replacing the script: MariaDB becomes PID 1
exec mysqld_safe
