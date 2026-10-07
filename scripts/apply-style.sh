#!/usr/bin/env bash
# Aplica o visual: fontes locais na biblioteca de fontes, estilos globais com a identidade do
# GABRIEL.SYS (cores e tipografia) e o template "page" com menos espaço vazio no topo.
# Sem tema, plugin ou JavaScript novos. Idempotente.
set -euo pipefail
source "$(dirname "$0")/env.sh"
export WP_EXTRA_MOUNT="-v $PROJECT_DIR/scripts:/scripts:ro,Z -v $PROJECT_DIR/assets/fonts:/fonts-src:ro,Z"
wp() { "$PROJECT_DIR/scripts/wp.sh" "$@"; }

wp eval-file /scripts/fonts.php
wp eval-file /scripts/global-styles.php

# Template "page" do tema com o topo reduzido (margem 60 -> 30 e padding 60 -> 40).
page_template='<!-- wp:template-part {"slug":"header"} /-->

<!-- wp:group {"tagName":"main","style":{"spacing":{"margin":{"top":"var:preset|spacing|30"}}},"layout":{"type":"constrained"}} -->
<main class="wp-block-group" style="margin-top:var(--wp--preset--spacing--30)"><!-- wp:group {"align":"full","style":{"spacing":{"padding":{"top":"var:preset|spacing|40","bottom":"var:preset|spacing|60"}}},"layout":{"type":"constrained"}} -->
<div class="wp-block-group alignfull" style="padding-top:var(--wp--preset--spacing--40);padding-bottom:var(--wp--preset--spacing--60)"><!-- wp:post-featured-image {"style":{"spacing":{"margin":{"bottom":"var:preset|spacing|60"}}}} /-->

<!-- wp:post-title {"level":1} /-->

<!-- wp:post-content {"align":"full","layout":{"type":"constrained"}} /--></div>
<!-- /wp:group --></main>
<!-- /wp:group -->

<!-- wp:template-part {"slug":"footer"} /-->'
tpl_id="$(wp post list --post_type=wp_template --name=page --post_status=any --field=ID)"
if [ -z "$tpl_id" ]; then
  tpl_id="$(wp post create --post_type=wp_template --post_status=publish --post_title="Páginas" \
    --post_name=page --post_content="$page_template" --porcelain)"
  wp post term set "$tpl_id" wp_theme twentytwentyfive >/dev/null
  echo "template page criado ($tpl_id)"
else
  wp post update "$tpl_id" --post_content="$page_template" >/dev/null
  echo "template page atualizado ($tpl_id)"
fi
