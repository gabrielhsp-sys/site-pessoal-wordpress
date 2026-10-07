#!/usr/bin/env bash
# Sobe o pod (MariaDB + WordPress) só em 127.0.0.1:8080. Idempotente.
set -euo pipefail
source "$(dirname "$0")/env.sh"

if [ ! -f "$SECRETS_DIR/db.env" ]; then
  umask 077
  mkdir -p "$SECRETS_DIR"
  chmod 700 "$SECRETS_DIR"
  db_pass="$(head -c 32 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c 32)"
  root_pass="$(head -c 32 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c 32)"
  cat > "$SECRETS_DIR/db.env" <<EOT
MARIADB_DATABASE=wordpress
MARIADB_USER=wordpress
MARIADB_PASSWORD=$db_pass
MARIADB_ROOT_PASSWORD=$root_pass
WORDPRESS_DB_HOST=127.0.0.1
WORDPRESS_DB_NAME=wordpress
WORDPRESS_DB_USER=wordpress
WORDPRESS_DB_PASSWORD=$db_pass
EOT
  chmod 600 "$SECRETS_DIR/db.env"
  echo "credenciais do banco criadas em $SECRETS_DIR/db.env"
fi

if ! podman pod exists "$POD"; then
  podman pod create --name "$POD" -p 127.0.0.1:8080:8080
fi
podman volume exists "$DB_VOLUME" || podman volume create "$DB_VOLUME" >/dev/null
podman volume exists "$WP_VOLUME" || podman volume create "$WP_VOLUME" >/dev/null

mkdir -p "$PROJECT_DIR/export"
podman unshare chown 33:33 "$PROJECT_DIR/export"

if ! podman container exists "$POD-db"; then
  podman create --pod "$POD" --name "$POD-db" --env-file "$SECRETS_DIR/db.env" \
    -v "$DB_VOLUME":/var/lib/mysql:Z "$DB_IMAGE" >/dev/null
fi
if ! podman container exists "$POD-wp"; then
  podman create --pod "$POD" --name "$POD-wp" --env-file "$SECRETS_DIR/db.env" \
    -v "$WP_VOLUME":/var/www/html:Z \
    -v "$PROJECT_DIR/config/apache/ports.conf":/etc/apache2/ports.conf:ro,Z \
    -v "$PROJECT_DIR/config/apache/000-default.conf":/etc/apache2/sites-available/000-default.conf:ro,Z \
    -v "$PROJECT_DIR/export":/export:Z \
    "$WP_IMAGE" >/dev/null
fi
podman pod start "$POD" >/dev/null

for _ in $(seq 1 60); do
  code="$(curl -s -o /dev/null -w '%{http_code}' "$SITE_URL/" || true)"
  case "$code" in 200|301|302) echo "WordPress no ar em $SITE_URL (HTTP $code)"; exit 0;; esac
  sleep 2
done
echo "WordPress não respondeu em $SITE_URL" >&2
exit 1
