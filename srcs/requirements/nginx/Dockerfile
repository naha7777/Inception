FROM	debian:bookworm

# nginx setup
RUN		apt-get update -y && apt-get upgrade -y && apt-get install nginx -y

# TSL key and certificate generation
RUN		mkdir -p /etc/nginx/ssl
RUN		apt-get install openssl -y
RUN		openssl req -x509 -nodes \
		-out /etc/nginx/ssl/inception.crt \
		-keyout /etc/nginx/ssl/inception.key \
		-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=anacharp.42.fr/UID=anacharp"

# stock nginx config file
RUN		mkdir -p /var/run/nginx
COPY	conf/nginx.conf /etc/nginx/nginx.conf

# check permissions
RUN		mkdir -p /var/www/html
RUN		chmod 755 /var/www/html
RUN		chown -R www-data:www-data /var/www/html

# Listen on port 443
EXPOSE	443

# launch nginx
CMD		[ "nginx", "-g", "daemon off;" ]
