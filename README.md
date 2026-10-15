_This project has been created as part of the 42 curriculum by anacharp._

# Inception

## Description
Inception is a system administration project built around Docker. It consists of building our own Docker images for NGINX, MariaDB and WordPress (with php-fpm), then using Docker Compose to launch them and connect them together through a dedicated network, with persistent storage for the website files and the database.

First what is Docker ?\
Docker is an **open source platform** used to package an **app and its dependencies** together. Dependencies can be libraries, code, configuration files... Docker groups them in an isolated environment called a **container**. Containers can communicate with each other thanks to **Docker networks**, which are declared and configured by **Docker Compose**.

Before talking about containers, we need to talk about the **Docker image**.\
An **image** contains all the information needed to create a container: a container is built from an image.\
To create an image, we write all this information in a **Dockerfile**. A Dockerfile can also start from an existing image, in order to build a new image on top of another one.

When all our images are ready to be used, we have to create a **docker-compose.yml**.\
This file lets us run containers and connect them together when needed, by declaring and configuring the networks they share. We can also make some files persistent.

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
- I first chose Ubuntu for my virtual machine OS, but I realised that the school computers and sgoinfre would not support it, so I switched to Debian.
- I wanted a non-graphical VM, but VirtualBox installed Debian automatically without asking me anything, and with a graphical interface. Configuring Debian without a graphical interface seemed too complicated, so I kept it, and it turned out to be helpful.
- I used my host machine with SSH and Remote-SSH to do my whole project. It allows me to connect to the VM and git clone my project without creating another SSH key.
- I chose a Debian image instead of an Alpine image because I have already worked with Debian, which is very well documented and makes it easy to install Docker.
- I also chose not to use Secrets because I thought a `.env` file was enough.

### Virtual Machines vs Docker
A virtual machine simulates an entire computer using its own OS, whereas Docker shares the host kernel. This makes Docker lighter and faster than a virtual machine.\
In addition, creating a virtual machine is like creating a new computer. Docker, which can also be used inside a virtual machine, gives us the freedom to deploy an application on ANY computer and any OS, so it can be launched anywhere, by anyone. In a container, the app has everything it needs and can be used from anywhere.

A virtual machine is designed to run another OS on a machine. You can run tests on it without any danger.

Docker is a lightweight, portable and fast way to package and launch applications in an isolated environment. It is very useful for a group project, for example, or for creating a web server.

### Secrets vs Environment Variables
They differ in terms of security and how they are stored:
- Environment variables are visible in the container's metadata.
- Docker Secrets are encrypted temporary files. They can only be accessed through specific services.

### Docker Network vs Host Network
Docker Network (= bridge mode) isolates the container's network in its own virtual namespace using Network Address Translation (NAT), while host mode removes network isolation completely, allowing the container to share the host machine's network stack directly.

#### Bridge Mode (--network bridge)
When we launch a container without specifying a network, Docker places it on a virtual bridge. The container behaves like a separate computer connected to a local router. If a containerized web server listens on port 80, it is hidden from the outside world. We must map it to a host port (`docker run -p 8080:80 nginx`). Traffic arriving on the host's port 8080 is routed via NAT to the container's port 80. If we create a user-defined bridge network, containers can securely talk to each other using their container names as domain names (automatic DNS resolution).

#### Host Mode (--network host)
Host mode skips the virtual bridge entirely. The container acts as if the application were running directly on our host operating system. If the containerized application opens port 80, it instantly occupies port 80 on the actual host machine's IP address. No `-p` port mapping flag is used. Containers cannot communicate via internal Docker DNS names. They must reference each other using `localhost` or the host's actual IP address.

### Docker Volumes vs Bind Mounts
There are many ways to store persistent data in a Docker architecture.

To use a **bind mount**, we must specify a directory or a file with an absolute path when we create the container.

A **volume** is managed by Docker. It is created on request if a volume with that name does not already exist. Once created, a volume is only removed if the admin does it intentionally. By default, it is a directory stored in `/var/lib/docker/volumes` and managed by the Docker API.\
We can list volumes with `docker volume ls`, create one with `docker volume create`, delete one with `docker volume rm` and clean unused ones with `docker volume prune`.

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
