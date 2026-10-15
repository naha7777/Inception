COMPOSE = docker compose -f srcs/docker-compose.yml

all:
	mkdir -p /home/anacharp/data/wordpress /home/anacharp/data/mariadb
	$(COMPOSE) up -d --build

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

down:
	$(COMPOSE) down -v

fclean:
	$(COMPOSE) down -v
	sudo rm -rf /home/anacharp/data/mariadb/* /home/anacharp/data/wordpress/*

re: fclean all

.PHONY: all stop start down fclean re
