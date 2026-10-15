## Setup
You can connect to the virtual machine over SSH from the host machine and clone the project from there.

1. Clone the repository.
2. Create the `.env` file in `srcs/`, following the `.env.example` template. Make sure the email addresses contain an `@`, otherwise WordPress will not install correctly.
3. Connect to the virtual machine to run the tests.
4. Using `sudo`, remove the `data` folder if it already exists.
5. Go to the cloned `Inception` folder.

## Launch

```bash
make
```

which is equivalent to:

```bash
sudo mkdir -p /home/anacharp/data/wordpress
sudo mkdir -p /home/anacharp/data/mariadb
docker compose -f srcs/docker-compose.yml up -d --build
```

To stop:

```bash
make stop
```

To restart after a stop:
```bash
make restart
```

## Checks

Check the HTML served by NGINX:

```bash
curl -k https://anacharp.42.fr
```

Check the logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

List all WordPress users with their emails and roles:

```bash
docker exec -it wordpress wp user list --allow-root --path=/var/www/html
```

List the users with their IDs, logins and roles only:

```bash
docker exec wordpress wp user list --allow-root --path=/var/www/html --fields=ID,user_login,roles
```

Check the open ports:

```bash
sudo ss -tlnp | grep -E ':80|:443'
```

You can also open a browser and go to one of these addresses:
- `https://localhost:443`
- `https://anacharp.42.fr`

## Cleanup

When you are done, run:

```bash
make fclean
```
