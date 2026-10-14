FROM	debian:bookworm

RUN		apt-get update -y && apt-get upgrade -y \
		&& apt-get install mariadb-server -y

COPY	conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY	create_database.sh /app/create_database.sh
RUN		chmod +x /app/create_database.sh

EXPOSE	443

CMD		["/app/create_database.sh"]
