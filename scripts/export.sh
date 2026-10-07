#!/usr/bin/env bash
# Exporta o site com o Simply Static para export/, troca as URLs para o endereço
# público e copia o resultado para docs/ (servido pelo GitHub Pages).
set -euo pipefail
source "$(dirname "$0")/env.sh"
wp() { "$PROJECT_DIR/scripts/wp.sh" "$@"; }

# Bloqueia chamadas HTTP do WordPress para fora; o próprio site (127.0.0.1) continua liberado.
wp config set WP_HTTP_BLOCK_EXTERNAL true --raw >/dev/null

host="${PUBLIC_URL#https://}"
wp option patch update simply-static delivery_method local >/dev/null
wp option patch update simply-static local_dir /export/ >/dev/null
wp option patch update simply-static destination_url_type absolute >/dev/null
wp option patch update simply-static destination_scheme https:// >/dev/null
wp option patch update simply-static destination_host "$host" >/dev/null
# Só a home e as páginas; CSS, JS e imagens usados entram porque o HTML aponta para eles.
# Sem crawler de autor, de feed, de REST API nem cópia integral de wp-includes e do tema
# (o smart_crawl força a cópia de wp-includes inteiro, por isso fica desligado).
wp option patch update simply-static crawlers '["home","post_type"]' --format=json >/dev/null
wp option patch update simply-static post_types '["page"]' --format=json >/dev/null
wp option patch update simply-static post_types_configured true --format=json >/dev/null
wp option patch update simply-static smart_crawl false --format=json >/dev/null

# Esvazia a saída anterior (os arquivos pertencem ao usuário 33 do contêiner).
podman unshare find "$PROJECT_DIR/export" -mindepth 1 -delete

started="$(wp eval 'echo \Simply_Static\Plugin::instance()->run_static_export() ? "1" : "0";')"
[ "$started" = 1 ] || { echo "o Simply Static não iniciou o export" >&2; exit 1; }

for _ in $(seq 1 150); do
  sleep 4
  active="$(wp eval 'echo \Simply_Static\Plugin::instance()->is_export_active() ? "1" : "0";')"
  [ "$active" = 0 ] && break
done
[ "$active" = 0 ] || { echo "export não terminou em 10 minutos" >&2; exit 1; }
wp option get simply-static --format=json \
  | python3 -c 'import json,sys; m=json.load(sys.stdin).get("archive_status_messages") or {}; [print("-", k+":", v.get("message","")) for k,v in m.items()]'
[ -f "$PROJECT_DIR/export/index.html" ] || { echo "export/index.html ausente" >&2; exit 1; }

rm -rf "$PROJECT_DIR/docs"
cp -r "$PROJECT_DIR/export" "$PROJECT_DIR/docs"
touch "$PROJECT_DIR/docs/.nojekyll"
# Metadados que apontam para endpoints dinâmicos inexistentes no site estático.
find "$PROJECT_DIR/docs" -name '*.html' -exec sed -i -E \
  -e 's#<link rel="EditURI"[^>]*>##' -e 's#<link rel="shortlink"[^>]*>##' {} +
echo "export copiado para docs/ ($(find "$PROJECT_DIR/docs" -type f | wc -l) arquivos)"
