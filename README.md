*This project has been created as part of the 42 curriculum.*

# Inception

## Description

Inception is a system administration project from the 42 school curriculum. The goal is to set up a small but complete web infrastructure using Docker, where each service runs in its own dedicated container. The infrastructure serves a WordPress website over HTTPS, backed by a MariaDB database, with NGINX as the only entry point.

The project demonstrates key concepts in containerization, networking, security, and service orchestration using Docker Compose.

## Architecture

The infrastructure consists of three containers communicating over a private Docker network:

- **NGINX** — the only entry point, listens on port 443 (HTTPS/TLS) and forwards PHP requests to WordPress
- **WordPress + php-fpm** — runs the WordPress application and processes PHP, communicates with MariaDB for data
- **MariaDB** — stores the WordPress database, accessible only from within the Docker network

Two persistent volumes store data on the host machine at `/home/antran/data/`:
- `db_data` — the MariaDB database files
- `wp_data` — the WordPress website files

## Instructions

### Prerequisites

- Docker and Docker Compose installed
- `make` installed
- Add the domain to `/etc/hosts`:
```bash
  echo "127.0.0.1 antran.42.fr" | sudo tee -a /etc/hosts
```

### Setup secrets (required before first run)

These files are not included in the repository for security reasons. Create them manually:

```bash
mkdir -p secrets
echo "your_root_password" > secrets/db_root_password.txt
echo "your_user_password" > secrets/db_password.txt
echo "WP_ADMIN_PASSWORD=your_admin_password" > secrets/credentials.txt
echo "WP_USER_PASSWORD=your_user_password" >> secrets/credentials.txt
```

### Setup environment file

Create `srcs/.env`:

```bash
cat > srcs/.env << EOF
DOMAIN_NAME=antran.42.fr
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
WP_TITLE=Antran's Inception Site
WP_ADMIN_USER=antranboss
WP_ADMIN_EMAIL=antran@antran.42.fr
WP_USER=antranwriter
WP_USER_EMAIL=writer@antran.42.fr
EOF
```

### Run the project

```bash
make        # build and start all containers
make down   # stop and remove containers
make clean  # remove containers and images
make fclean # full reset including all data
make re     # full reset and restart
```

### Access the site

- Website: `https://antran.42.fr`
- Admin panel: `https://antran.42.fr/wp-admin`
- Admin login: username defined in `WP_ADMIN_USER` in `.env`

## Resources

- [Docker documentation](https://docs.docker.com)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [MariaDB documentation](https://mariadb.com/kb/en/)
- [WordPress CLI documentation](https://wp-cli.org/)
- [PHP-FPM documentation](https://www.php.net/manual/en/install.fpm.php)

### AI usage

Claude (Anthropic) was used throughout this project to:
- Explain Docker concepts (containers, networks, volumes, entrypoints, PID 1)
- Debug issues during container setup (race conditions, pre-baked data, certificate errors)
- Draft and review Dockerfiles and shell scripts
- All generated content was reviewed, tested, and understood before being used

## Design Choices

### Virtual Machines vs Docker
A VM virtualizes an entire operating system including the kernel, making it heavy and slow to start. Docker containers share the host kernel and only package the application and its dependencies, making them lightweight and fast. For this project, Docker is ideal since each service (NGINX, WordPress, MariaDB) only needs its own process space, not a full OS.

### Secrets vs Environment Variables
Environment variables are visible to any process in the container and can be inspected with `docker inspect`. Docker secrets are mounted as files at `/run/secrets/` and are only accessible to the specific container that needs them. Passwords and credentials are stored as secrets; non-sensitive configuration (domain name, database name) goes in `.env`.

### Docker Network vs Host Network
Using `network: host` would expose all container ports directly on the host machine, bypassing Docker's network isolation. Our custom `inception` bridge network means containers can only communicate with each other through defined connections, and only port 443 is exposed to the outside world through NGINX.

### Docker Volumes vs Bind Mounts
Named volumes are managed entirely by Docker and stored in Docker's internal directory. Bind mounts link a specific host path directly into the container. We use bind mounts pointing to `/home/antran/data/` because the subject explicitly requires data to be available at that path on the host machine.