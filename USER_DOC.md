# User Documentation

This document explains how to use and administer the Inception stack day to day.

## Services provided

The stack runs three containers:

| Service | Role |
|---|---|
| **NGINX** | Web server and only entry point of the stack. It serves the website over HTTPS (port 443, TLS). |
| **WordPress + php-fpm** | The website itself and its administration panel. |
| **MariaDB** | The database used by WordPress (posts, users, settings). |

The containers talk to each other through a dedicated Docker network. Website files and database content are stored persistently in `/home/anacharp/data/wordpress` and `/home/anacharp/data/mariadb`, so they survive a restart.

## Start and stop the stack

All commands are run from the root of the `Inception` folder, on the virtual machine.

| Action | Command |
|---|---|
| Build and start everything | `make` |
| Stop the stack (data is kept) | `make stop` |
| Restart after a stop | `make start` |
| Remove everything, including the data | `make fclean` |

> **Warning:** `make fclean` deletes the website and database content. Use it only when you want to start from scratch.

## Access the website and the administration panel

- **Website:** https://anacharp.42.fr
- **Administration panel:** https://anacharp.42.fr/wp-admin

The domain `anacharp.42.fr` must point to the VM's IP address (for example through `/etc/hosts` on the machine running the browser).

The HTTPS certificate is self-signed, so the browser will show a security warning the first time. Accept it to continue.

In the administration panel, log in with the administrator account to write posts, manage pages, themes and plugins, and create or edit users. The second (regular) user can also log in at the same address, but with fewer permissions.

## Manage credentials

All credentials are defined in the `.env` file located in `srcs/`. This file is **not** committed to the repository: each installation creates its own from the `.env.example` template. It contains:

- the database name, user and passwords,
- the WordPress administrator and regular user accounts (login, password, email).

Notes:
- Email addresses must contain an `@`, otherwise WordPress will not install correctly.
- Keep `.env` private and never share it.
- The credentials in `.env` are only used at the **first installation**. Changing them afterwards has no effect on an existing website or database. To apply new values, run `make fclean` and then `make` (this erases the data).

To change a WordPress password without erasing anything, either use the administration panel (**Users > Profile**), or run:

```bash
docker exec wordpress wp user update <user_login> --user_pass=<new_password> --allow-root --path=/var/www/html
```

List the existing accounts (ID, login, roles):

```bash
docker exec wordpress wp user list --allow-root --path=/var/www/html --fields=ID,user_login,roles
```

## Check that the services are running correctly

Check that the three containers are up:

```bash
docker ps
```

Check that NGINX serves the website:

```bash
curl -k https://anacharp.42.fr
```

Check that the expected ports are open:

```bash
sudo ss -tlnp | grep -E ':80|:443'
```

Read the logs of all services (or add a service name at the end to see only one):

```bash
docker compose -f srcs/docker-compose.yml logs
```

If a container is not running, or the site does not load, check the logs first. The most common cause is an invalid value in the `.env` file.
