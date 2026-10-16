FROM	debian:bookworm

# nginx setup : download available packages, update packages, install web server
RUN		apt-get update -y && apt-get upgrade -y && apt-get install nginx -y

# TLS key and certificate generation
# Create a directory to put the key and the certificate
# /etc has config files
RUN		mkdir -p /etc/nginx/ssl
# install openssl to generate a certificate
RUN		apt-get install openssl -y
# certificate generation, create it without asking, no secret sentence 
# to protect the key, write certificate on public part, key on private
RUN		openssl req -x509 -nodes \
		-out /etc/nginx/ssl/inception.crt \
		-keyout /etc/nginx/ssl/inception.key \
		-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=anacharp.42.fr/UID=anacharp"

# create a directory on /var/run
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
