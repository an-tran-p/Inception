NAME		= inception
COMPOSE		= docker compose -f srcs/docker-compose.yml
DATA_DIR	= /home/$(USER)/data

all: up

up: data-dirs
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

restart: down up

build: data-dirs
	$(COMPOSE) build

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

data-dirs:
	mkdir -p $(DATA_DIR)/db_data
	mkdir -p $(DATA_DIR)/wp_data

clean: down
	docker system prune -af

fclean: clean
	sudo rm -rf $(DATA_DIR)/db_data/*
	sudo rm -rf $(DATA_DIR)/wp_data/*

re: fclean up

.PHONY: all up down stop start restart build logs ps data-dirs clean fclean re