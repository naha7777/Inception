# Developer Documentation

This document explains how to set up the Inception environment from scratch, build and run the stack, manage the containers and volumes, and understand where the data is stored.

## Prerequisites

- A Linux virtual machine (Debian) with `sudo` rights
- Docker Engine and the Docker Compose plugin
- `make` and `git`
- The domain name pointing to the VM, in `/etc/hosts` of the machine running the browser:

```
<VM_IP>  anacharp.42.fr
```

Check the installation:

```bash
docker --version
docker compose version
make --version
```

## Project structure

```
Inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
└── srcs/
    ├── .env                  # credentials (not committed)
    ├── .env.example          # template
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/            # Dockerfile + conf + tools
        ├── wordpress/        # Dockerfile + conf + setup script
        └── mariadb/          # Dockerfile + conf + setup script
```

(Adapt this tree to your real folders.)

- **Makefile**: entry point, wraps the Docker Compose commands.
- **docker-compose.yml**: declares the services, the network, the volumes and the environment.
- **Dockerfiles**: one per service, each builds its own image from Debian.
- **.env**: all the variables and credentials used at build and run time.

## Setup from scratch

1. Clone the repository.
2. Create the `.env` file in `srcs/`, following the `.env.example` template. Make sure the email addresses contain an `@`, otherwise WordPress will not install correctly.
3. If a `data` folder already exists from a previous installation, remove it with `sudo`:

```bash
sudo rm -rf /home/anacharp/data
```

4. Go to the cloned `Inception` folder.

## Build and launch

```bash
make
```

which is equivalent to:

```bash
sudo mkdir -p /home/anacharp/data/wordpress
sudo mkdir -p /home/anacharp/data/mariadb
docker compose -f srcs/docker-compose.yml up -d --build
```

| Action | Command |
|---|---|
| Build and start | `make` |
| Stop (data is kept) | `make stop` |
| Start again after a stop | `make start` |
| Remove containers, images and data | `make fclean` |

## Manage the containers

```bash
# State of the stack
docker compose -f srcs/docker-compose.yml ps
docker ps -a

# Logs of all services, or of one service, in real time
docker compose -f srcs/docker-compose.yml logs
docker compose -f srcs/docker-compose.yml logs -f nginx

# Restart or rebuild a single service
docker compose -f srcs/docker-compose.yml restart wordpress
docker compose -f srcs/docker-compose.yml up -d --build nginx

# Rebuild everything without using the cache
docker compose -f srcs/docker-compose.yml build --no-cache

# Open a shell inside a container
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash

# Stop and remove the containers and the network (volumes are kept)
docker compose -f srcs/docker-compose.yml down
```

If a container has no `bash`, use `sh` instead.

## Useful checks

Check the HTML served by NGINX:

```bash
curl -k https://anacharp.42.fr
```

Check the TLS version and certificate:

```bash
openssl s_client -connect anacharp.42.fr:443 -tls1_2 </dev/null
```

Check the open ports:

```bash
sudo ss -tlnp | grep -E ':80|:443'
```

Check the NGINX configuration syntax:

```bash
docker exec nginx nginx -t
```

Check that php-fpm is running in the WordPress container:

```bash
docker exec wordpress ps aux
```

List all WordPress users with their emails and roles:

```bash
docker exec -it wordpress wp user list --allow-root --path=/var/www/html
```

List only the IDs, logins and roles:

```bash
docker exec wordpress wp user list --allow-root --path=/var/www/html --fields=ID,user_login,roles
```

Connect to the database from the MariaDB container:

```bash
docker exec -it mariadb mysql -u <db_user> -p
```

Then, for example:

```sql
SHOW DATABASES;
USE <db_name>;
SHOW TABLES;
```

## Manage the network

```bash
docker network ls
docker network inspect <network_name>
```

The containers reach each other by service name (for example, WordPress connects to the database with the host `mariadb`) thanks to the automatic DNS of the user-defined network.

## Manage the images

```bash
docker images
docker image rm <image_name>
```

## Manage the volumes

```bash
docker volume ls
docker volume inspect <volume_name>
docker volume rm <volume_name>
docker volume prune
```

> **Warning:** removing a volume deletes its data.

## Where the data is stored and how it persists

| Data | Container path | Host path (VM) |
|---|---|---|
| WordPress files | `/var/www/html` | `/home/anacharp/data/wordpress` |
| MariaDB database | `/var/lib/mysql` | `/home/anacharp/data/mariadb` |

These two directories are mounted into the containers, so the data **survives** `make stop`, `make start` and even the deletion of the containers. It is only erased when the host directories are removed (`make fclean` or `sudo rm -rf /home/anacharp/data`).

Quick persistence test:
1. Create a post or a comment on the website.
2. Run `make stop`, then `make start`.
3. Check that the post is still there.

Note that the values from `.env` are only used during the first installation. If you change them afterwards, you must erase the data (`make fclean`) and rebuild.

## Cleanup

When you are done, run:

```bash
make fclean
```
