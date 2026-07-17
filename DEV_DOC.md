# Developer Documentation

## Prerequisites

- Docker and Docker Compose installed
- `make` installed
- Git

## Setting up from scratch

### 1. Clone the repository

```bash
git clone git@github.com:an-tran-p/Inception.git
cd Inception
```

### 2. Add domain to /etc/hosts

```bash
echo "127.0.0.1 antran.42.fr" | sudo tee -a /etc/hosts
```

### 3. Create secrets files

These are not in git for security reasons. Create them manually:

```bash
mkdir -p secrets
echo "your_root_password" > secrets/db_root_password.txt
echo "your_user_password" > secrets/db_password.txt
echo "WP_ADMIN_PASSWORD=your_admin_password" > secrets/credentials.txt
echo "WP_USER_PASSWORD=your_user_password" >> secrets/credentials.txt
```

### 4. Create the .env file

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

### 5. Build and launch

```bash
make
```

## Project structure