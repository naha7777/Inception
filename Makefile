COMPOSE = docker compose -f srcs/docker-compose.yml

all:
	sudo mkdir -p /home/anacharp/data/wordpress
	sudo mkdir -p /home/anacharp/data/mariadb
	$(COMPOSE) up -d --build

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

down:
	$(COMPOSE) down -v

fclean:
	$(COMPOSE) down -v
	sudo rm -rf /home/anacharp/data/mariadb/*
	sudo rm -rf /home/anacharp/data/wordpress/*

re: fclean all

.PHONY: all stop start down fclean re
