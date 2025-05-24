#!/bin/sh
set -e

mkdir -p /var/www/app/var/cache /var/www/app/var/log

# Récupère UID / GID du code monté
HOST_UID=$(stat -c '%u' /var/www/app)
HOST_GID=$(stat -c '%g' /var/www/app)

# ACL : www-data + UID numérique + groupe numérique
setfacl -R -m u:www-data:rwX \
            -m u:${HOST_UID}:rwX \
            -m g:${HOST_GID}:rwX \
            /var/www/app/var

setfacl -R -d -m u:www-data:rwX \
              -m u:${HOST_UID}:rwX \
              -m g:${HOST_GID}:rwX \
              /var/www/app/var

exec "$@"