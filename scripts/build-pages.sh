#!/usr/bin/env bash
# Cria ou atualiza as páginas a partir de content/pages/*.html (blocos Gutenberg),
# define a página inicial e o menu principal. Idempotente: casa as páginas pelo slug.
set -euo pipefail
source "$(dirname "$0")/env.sh"
export WP_EXTRA_MOUNT="-v $PROJECT_DIR/content/pages:/pages:ro,Z"
wp() { "$PROJECT_DIR/scripts/wp.sh" "$@"; }

# arquivo|slug|título da página|rótulo no menu
PAGES=(
  "01-inicio.html|inicio|Gabriel Henrique|Início"
  "02-passatempos.html|passatempos|Passatempos|Passatempos"
  "03-trabalho-e-estudo.html|trabalho-e-estudo|Trabalho e estudo|Trabalho e estudo"
  "04-formacao-academica.html|formacao-academica|Formação acadêmica|Formação acadêmica"
  "05-contato.html|contato|Contato|Contato"
)

nav=""
order=0
for entry in "${PAGES[@]}"; do
  IFS='|' read -r file slug title label <<<"$entry"
  order=$((order + 1))
  id="$(wp post list --post_type=page --name="$slug" --post_status=any --field=ID)"
  if [ -z "$id" ]; then
    id="$(wp post create "/pages/$file" --post_type=page --post_status=publish \
      --post_title="$title" --post_name="$slug" --menu_order="$order" \
      --comment_status=closed --ping_status=closed --porcelain)"
    echo "criada: $slug ($id)"
  else
    wp post update "$id" "/pages/$file" --post_title="$title" --menu_order="$order" \
      --comment_status=closed --ping_status=closed >/dev/null
    echo "atualizada: $slug ($id)"
  fi
  if [ "$slug" = inicio ]; then
    front_id="$id"
    url="$SITE_URL/"
  else
    url="$SITE_URL/$slug/"
  fi
  nav+="<!-- wp:navigation-link {\"label\":\"$label\",\"type\":\"page\",\"id\":$id,\"url\":\"$url\",\"kind\":\"post-type\"} /-->"
done

wp option update show_on_front page >/dev/null
wp option update page_on_front "$front_id" >/dev/null

# O tema de blocos usa o wp_navigation publicado mais recente como menu do cabeçalho.
# Remove o menu automático que o WordPress cria com a lista de páginas.
for other in $(wp post list --post_type=wp_navigation --post_status=any --field=ID); do
  [ "$(wp post get "$other" --field=post_name)" = menu-principal ] || wp post delete "$other" --force >/dev/null
done
nav_id="$(wp post list --post_type=wp_navigation --name=menu-principal --post_status=any --field=ID)"
if [ -z "$nav_id" ]; then
  wp post create --post_type=wp_navigation --post_status=publish --post_title="Menu principal" \
    --post_name=menu-principal --post_content="$nav" --porcelain >/dev/null
  echo "menu criado"
else
  wp post update "$nav_id" --post_content="$nav" >/dev/null
  echo "menu atualizado"
fi

# Rodapé próprio: o do tema traz links de exemplo ("Blog", "About"...) apontando para "#".
footer='<!-- wp:group {"tagName":"div","layout":{"type":"constrained"},"style":{"spacing":{"padding":{"top":"var:preset|spacing|50","bottom":"var:preset|spacing|50"}}}} --><div class="wp-block-group" style="padding-top:var(--wp--preset--spacing--50);padding-bottom:var(--wp--preset--spacing--50)"><!-- wp:site-title {"level":0} /--></div><!-- /wp:group -->'
footer_id="$(wp post list --post_type=wp_template_part --name=footer --post_status=any --field=ID)"
if [ -z "$footer_id" ]; then
  footer_id="$(wp post create --post_type=wp_template_part --post_status=publish --post_title="Rodapé" \
    --post_name=footer --post_content="$footer" --porcelain)"
  wp post term set "$footer_id" wp_theme twentytwentyfive >/dev/null
  wp post term set "$footer_id" wp_template_part_area footer >/dev/null
  echo "rodapé criado"
else
  wp post update "$footer_id" --post_content="$footer" >/dev/null
  echo "rodapé atualizado"
fi
