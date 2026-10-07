<?php
// Estilos globais do usuário: variação "Noon" do próprio Twenty Twenty-Five + dois ajustes.
// Roda via: scripts/wp.sh eval-file /scripts/global-styles.php
$theme_dir = get_stylesheet_directory();
$variation = json_decode( file_get_contents( $theme_dir . '/styles/02-noon.json' ), true );
unset( $variation['$schema'], $variation['title'] );

// Ajuste 1: corpo em peso 400 (o tema usa 300, traço fino demais para parágrafo longo).
$variation['styles']['typography']['fontWeight'] = '400';
// Ajuste 2: respiro antes de cada subseção (h2), para as seções não virarem um bloco só.
$variation['styles']['elements']['h2']['spacing']['margin']['top'] = 'var:preset|spacing|50';

$variation['version'] = 3;
$variation['isGlobalStylesUserThemeJSON'] = true;

$post_id = WP_Theme_JSON_Resolver::get_user_global_styles_post_id();
// Sem usuário logado (WP-CLI), o post nasce sem o termo do tema e o WordPress não o encontra.
wp_set_object_terms( $post_id, get_stylesheet(), 'wp_theme' );
$result = wp_update_post( array(
	'ID'           => $post_id,
	'post_content' => wp_slash( wp_json_encode( $variation ) ),
), true );
if ( is_wp_error( $result ) ) {
	WP_CLI::error( $result->get_error_message() );
}
wp_clean_theme_json_cache();
WP_CLI::success( "estilos globais gravados no post $post_id (variação Noon + 2 ajustes)" );
