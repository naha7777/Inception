_This project has been created as part of the 42 curriculum by anacharp._

# Inception

## Description
Inception is a system administration project built around Docker. It consists of building our own Docker images for NGINX, MariaDB and WordPress (with php-fpm), then using Docker Compose to launch them and connect them together through a dedicated network, with persistent storage for the website files and the database.

First what is Docker ?\
Docker is...

## Instructions
### Setup
You can connect to the virtual machine over SSH from the host machine and clone the project from there.

1. Clone the repository.
2. Create the `.env` file in `srcs/`, following the `.env.example` template. Make sure the email addresses contain an `@`, otherwise WordPress will not install correctly.
3. Connect to the virtual machine to run the tests.
4. Using `sudo`, remove the `data` folder if it already exists.
5. Go to the cloned `Inception` folder.

### Launch

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

### Checks

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

### Cleanup

When you are done, run:

```bash
make fclean
```

## Project Description
Section must also explain the use of Docker and the sources included in the project. It must indicate the main design choices, as well as a comparison between

### Virtual Machines vs Docker

### Secrets vs Environment Variables

### Docker Network vs Host Network

### Docker Volumes vs Bind Mounts

## Resources
### Documentation and references
[Debian](https://www.debian.org/distrib/)\
[Docker](https://www.nicelydev.com/docker/mots-cles-supplementaires-dockerfile#:~:text=Le%20mot%2Dcl%C3%A9%20EXPOSE%20permet,utiliser%20l'option%20%2Dp%20)\
[Inception Tuto FR](https://inception.cluzet.fr/)\
[Docker bonnes pratiques](https://librecours.net/modules/picasoft/run/dk02/solweb/co/dk02_1.html)\
[Inception 42 project guide](https://github.com/azedineouhadou/inception-42)\
[Guide to Dockerizing Your First Infrastructure](https://devabdilah.medium.com/inception-42-a-comprehensive-guide-to-dockerizing-your-first-infrastructure-part-iii-a10e93e9d922)\
[Inception Github](https://github.com/Forstman1/inception-42)\
[Docker NGINX, WordPress, MariaDB Tutorial Inception](https://dev.to/alejiri/docker-nginx-wordpress-mariadb-tutorial-inception42-1eok)\
[Another git](https://git.chevro.fr/42-cestoliv/inception)\
[Inception](https://medium.com/@imyzf/inception-3979046d90a0)\
[SSH Server on Debian](https://alexhost.com/faq/how-to-install-and-configure-an-ssh-server-on-debian/)\
[Install Docker Engine on Debian](https://docs.docker.com/engine/install/debian/)\
[Nginx](https://www.ovhcloud.com/fr/learn/what-is-nginx/)\
[MariaDB](https://mariadb.org/fr/)\
[WordPress](https://verycloud.fr/docs/article/wordpress-debian13)\
[PHP](https://kinsta.com/fr/blog/qu-est-ce-que-php/)

### Use of AI
An AI assistant was used as a support tool during this project, mainly for:
- **Port forwarding** between the host and the VM.
- **Debugging**: finding typos and syntax mistakes in Dockerfiles and shell scripts.
- **Understanding concepts**: why a bind-mounted volume hides the content of an image, PID 1 and daemons.
- **Verification**: commands to verify the setup.
- **Documentation**: proofreading and translating this README.
