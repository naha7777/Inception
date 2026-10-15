_This project has been created as part of the 42 curriculum by anacharp._

# Inception

## Description
Inception is a Docker project. We have to create images about nginx, mariadb and wordpress et use Docker Compose to launch them and connect them in the best way.

First what is Docker ?\
Docker is...

## Instructions
Je peux me connecter en SSH à ma VM depuis ma machine hote, c'est de la que je peux git clone le projet.\
Ensuite on peut créer le .env en suivant l'example du `.env.example` en veillant à bien mettre `@` pour les adresses emails sinon cela ne fonctionnera pas.\
Enfin on peut se rendre directement dans la vm pour faire nos tests.\
Tout d'abord se mettre en sudo et supprimer le dossier `data` si il existe.\
Puis se rendre dans notre dossier `Inception` que nous venons de cloner.\
Nous pouvons maintenant lancer le programme avec :
```bash
make
```
or
```bash
sudo mkdir -p /home/anacharp/data/wordpress
sudo mkdir -p /home/anacharp/data/mariadb
docker compose -f srcs/docker-compose.yml up -d --build
```
Puis :
```bash
make start
```

Ensuite on a la possibilité de :
Check the html:
```bash
curl -k https://anacharp.42.fr
```

Check logs:
```bash
docker compose -f srcs/docker-compose.yml logs
```

Check all users, their mails and roles:
```bash
docker exec -it wordpress wp user list --allow-root --path=/var/www/html
```

Check users, their IDs, logins and roles:
```bash
docker exec wordpress wp user list --allow-root --path=/var/www/html --fields=ID,user_login,roles
```

Check ports:
```bash
sudo ss -tlnp | grep -E ':80|:443'
```

Nous pouvons également ouvrir un navigateur de rechercher et mettre l'un de ces liens :
- `https://localhost:443`
- `https://anacharp.42.fr`

Enfin, il ne faut pas oublier d'utiliser la commande `make fclean` quand on a terminé.

## Project Description
Section must also explain the use of Docker and the sources included in the project. It must indicate the main design choices, as well as a comparison between

### Virtual Machines vs Docker

### Secrets vs Environment Variables

### Docker Network vs Host Network

### Docker Volumes vs Bind Mounts

## Resources
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
