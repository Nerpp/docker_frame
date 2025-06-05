#!/bin/sh
set -e

envsubst '$PROJECT_DIR' < /templates/vhosts.conf > /etc/apache2/sites-enabled/000-default.conf

PROJECT_PATH="/var/www/${PROJECT_DIR}"

if [ -d "$PROJECT_PATH" ]; then
  mkdir -p "$PROJECT_PATH/var/cache" "$PROJECT_PATH/var/log"

  # Récupère UID / GID du code monté
  HOST_UID=$(stat -c '%u' "$PROJECT_PATH")
  HOST_GID=$(stat -c '%g' "$PROJECT_PATH")

  # ACL : www-data + UID numérique + groupe numérique
  setfacl -R -m u:www-data:rwX \
              -m u:${HOST_UID}:rwX \
              -m g:${HOST_GID}:rwX \
              "$PROJECT_PATH/var"

  setfacl -R -d -m u:www-data:rwX \
                -m u:${HOST_UID}:rwX \
                -m g:${HOST_GID}:rwX \
                "$PROJECT_PATH/var"
fi

exec "$@"

