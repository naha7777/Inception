FROM	debian:bookworm

# installation de nginx
RUN		apt-get update
RUN		apt-get upgrade -y
RUN		apt-get install nginx -y

# génerer un certificat et une clé TSL
RUN		mkdir -p /etc/nginx/ssl
RUN		apt-get install openssl -y
RUN		openssl req -x509 -nodes \
		-out /etc/nginx/ssl/inception.crt \
		-keyout /etc/nginx/ssl/inception.key \
		-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=anacharp.42.fr/UID=anacharp"

# stocker les fichiers de config de NGINX
RUN		mkdir -p /var/run/nginx
COPY	conf/nginx.conf /etc/nginx/nginx.conf

# checker qu'on a les droits
RUN		mkdir -p /var/www/html
RUN		chmod 755 /var/www/html
RUN		chown -R www-data:www-data /var/www/html

EXPOSE 443

# lancer NGINX
CMD		[ "nginx", "-g", "daemon off;" ]
