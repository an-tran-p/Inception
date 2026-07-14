#!/bin/bash
set -e

mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/antran.42.fr.key \
    -out /etc/nginx/ssl/antran.42.fr.crt \
    -subj "/C=FI/ST=Uusimaa/L=Espoo/O=42Hive/CN=antran.42.fr"

echo "Starting NGINX..."
exec nginx -g "daemon off;"