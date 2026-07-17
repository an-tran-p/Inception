# User Documentation

## What is this?

This project runs a WordPress website served over HTTPS using three Docker containers:
- A web server (NGINX) that handles incoming connections
- A WordPress application that serves the website
- A database (MariaDB) that stores all website content

## Starting and stopping the project

**Start everything:**
```bash
make
```

**Stop everything (data is preserved):**
```bash
make down
```

**Full reset (deletes all data):**
```bash
make fclean
make
```

## Accessing the website

Once running, open your browser and go to: https://antran.42.fr

You will see a security warning about the certificate — this is expected since we use a self-signed certificate. Click **Advanced** then **Accept the Risk and Continue** to proceed.

## Accessing the admin panel

Go to: https://antran.42.fr/wp-admin

Login with:
- **Admin username:** `antranboss`
- **Admin password:** the value of `WP_ADMIN_PASSWORD` in `secrets/credentials.txt`

## Users

There are two users created automatically:

| Username | Role | Password location |
|---|---|---|
| antranboss | Administrator | `secrets/credentials.txt` → `WP_ADMIN_PASSWORD` |
| antranwriter | Author | `secrets/credentials.txt` → `WP_USER_PASSWORD` |

## Managing credentials

All passwords are stored in the `secrets/` folder:
- `secrets/db_root_password.txt` — MariaDB root password
- `secrets/db_password.txt` — MariaDB WordPress user password
- `secrets/credentials.txt` — WordPress admin and user passwords

These files are never committed to git for security reasons.

## Checking that services are running

```bash
docker ps
```

You should see three containers all with status `Up`:
- `nginx`
- `wordpress`  
- `mariadb`

To see logs for a specific service:
```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```