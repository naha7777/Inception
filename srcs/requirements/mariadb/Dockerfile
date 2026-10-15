FROM	debian:bookworm

# install mariadb
RUN		apt-get update -y && apt-get upgrade -y \
		&& apt-get install mariadb-server -y

# change mariadb configuration
COPY	conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY	tools/create_database.sh /app/create_database.sh
RUN		chmod +x /app/create_database.sh

# listen port 3306
EXPOSE	3306

# execute the script
CMD		["/app/create_database.sh"]
