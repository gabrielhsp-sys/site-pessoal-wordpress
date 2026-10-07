#!/usr/bin/env bash
# Roda o WP-CLI dentro do pod. Uso: scripts/wp.sh <comando wp> ...
# Variáveis opcionais: WP_EXTRA_MOUNT="-v host:container:ro,Z"
set -euo pipefail
source "$(dirname "$0")/env.sh"
# shellcheck disable=SC2086
exec podman run --rm -i --pod "$POD" --user 33:33 --env-file "$SECRETS_DIR/db.env" \
  -v "$WP_VOLUME":/var/www/html:Z ${WP_EXTRA_MOUNT:-} "$CLI_IMAGE" wp "$@"
