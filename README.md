_This project has been created as part of the 42 curriculum by anacharp._

# Inception

## Description
Inception is a system administration project built around Docker. It consists of building our own Docker images for NGINX, MariaDB and WordPress (with php-fpm), then using Docker Compose to launch them and connect them together through a dedicated network, with persistent storage for the website files and the database.

First what is Docker ?\
Docker is an **open source platform** used to group together an **app and those dependencies**. Dependencies can be libraries, code, configuration files... It group them in an isolated environment called **container**. All the containers will be able to communicate thanks to **Docker Compose**.

Before the container, we talk about the **Docker image**. This image has all the informations we need to create a container. The container is based from the image to build himself. To create an image, we need to put all the informations on a **Dockerfile**. We also can put an image on a Dockerfile to build an image with another image.

When we have all our images ready to be used, we have to create a **docker-compose.yml**. This file give us the power of using containers and connect containers if we need to do it. We also can make some files persistents.

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
### Choices
- I first have chosen Ubuntu for my virtual machine OS, but i realised that computers and sgoinfre will not make it so i changed for Debian.
- I wanted a non graphical VM, but VirtualBox installed automatically, i keeped it and finally it was helpfull.
- I used my host machine with SSH and Remote-SSH to do all my project, it gives to me the power to connect myself to the VM and git clone my project without creating another SSH key.
- I choose Debian image instead of Alpine image because I have already worked with Debian which is very documented and can install Docker easily.
- I also choose to not use Secrets because for me a .env was enough.

### Virtual Machines vs Docker
A virtual machine simulate an entire computer using his own OS when Docker share the host kernel. It makes Docker be more light and quick than a Virtual Machine. In addition, create a Virtual Machine is like create a new computer. But a Docker, which can also be used on a Virtual Machine by the way, just give us the freedom to deploy an application on ANY computer, and any OS so it can be lunch everywhere, by everyone. In a container the app has all she needs and can be used from everywhere.

A Virtual Machine is created to have another OS on a machine. You can do tests on it without danger.

Docker is a light, portable and quick way to package and launch applications on an isolated environment. It's very useful for a group project for example, or to create a web server.

### Secrets vs Environment Variables
There is a difference about security and saving way:
- Environment variables are saved in a visible way on container metadatas.
- Docker Secrets are encrypted temporary files. We can access it only by using some services.

### Docker Network vs Host Network
Docker Network (=bridge mode) isolates the container's network in its own virtual namespace using Network Adress Translation (NAT), while host mode removes network isolation completely, allowing the container to share the host machine's network stack directly.

#### Bridge Mode (--network bridge)
When we launch a container without specifying a network, Docker places it on a virtual bridge. The container behaves like a separate computer connected to a local router. If a containerized web server listens on port 80, it's hidden from the internet. We must map it to a host port (`docker run -p 8080:80 nginx). Traffic to the host on port 8080 is routed via NAT into the container's port 80. If we create a user-defined bridge network, containers can securely talk to each other using their container names as domain names (automatic DNS resolution).

#### Host Mode (--network host)
Host mode skips the virtual bridge entirely. The container acts as if the application were running directly on our host operating system. If the containerized application opens port 80, it instantly occupies port 80 on the actual host machine's IP address. No `-p` port mapping flag is used. Containers cannot communicate via internal Docker DNS names. They must reference each other using `localhost` or the host's actual IP address.

### Docker Volumes vs Bind Mounts
There is many ways to stock some persistent data on a Docker architecture.

For using a bind mount, when we create a container we must specify a directory or a file with an absolute path.

A volume is managed by Docker. It is created when we ask if his name doesn't exist already. When a volume is created, he will be clean only if the admin does it intentionally. It's a directory by default stocked on /var/lib/docker/volumes and managed by Docker API. We can list it with `docker volume ls`, create one with `docker volume create`, delete on with `docker volume rm` et clean with `docker volume prune`.

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
