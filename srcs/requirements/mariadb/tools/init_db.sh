#!/bin/bash
set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "First run: initializing database..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

    mysqld_safe --skip-networking &
    echo "Waiting for MariaDB to be ready..."
    until mariadb -u root -e "SELECT 1;" >/dev/null 2>&1; do
        sleep 1
    done
    echo "MariaDB is ready."

    mariadb -u root <<-EOSQL
        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOSQL

    mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown
fi

echo "Starting MariaDB..."
exec mysqld_safe