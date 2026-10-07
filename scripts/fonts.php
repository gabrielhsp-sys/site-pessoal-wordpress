<?php
// Registra as fontes do GABRIEL.SYS na biblioteca de fontes do WordPress (Font Library),
// com arquivos locais em wp-content/fonts. Fontes OFL-1.1 (licenças em assets/fonts/).
// Roda via: WP_EXTRA_MOUNT="-v .../assets/fonts:/fonts-src:ro,Z" scripts/wp.sh eval-file /scripts/fonts.php
wp_set_current_user( 1 ); // a API da biblioteca exige quem pode editar o tema

$families = array(
	array(
		'name'       => 'Bricolage Grotesque',
		'slug'       => 'bricolage-grotesque',
		'fontFamily' => '"Bricolage Grotesque", sans-serif',
		'faces'      => array(
			array( 'file' => 'bricolage-grotesque-latin-wght-normal.woff2', 'fontWeight' => '200 800' ),
		),
	),
	array(
		'name'       => 'IBM Plex Mono',
		'slug'       => 'ibm-plex-mono',
		'fontFamily' => '"IBM Plex Mono", ui-monospace, monospace',
		'faces'      => array(
			array( 'file' => 'ibm-plex-mono-latin-400-normal.woff2', 'fontWeight' => '400' ),
			array( 'file' => 'ibm-plex-mono-latin-600-normal.woff2', 'fontWeight' => '600' ),
		),
	),
);

$font_dir = wp_get_font_dir();
wp_mkdir_p( $font_dir['path'] );

function spw_rest( $method, $route, $params ) {
	$request = new WP_REST_Request( $method, $route );
	foreach ( $params as $key => $value ) {
		$request->set_param( $key, $value );
	}
	$response = rest_do_request( $request );
	if ( $response->is_error() ) {
		WP_CLI::error( $route . ': ' . $response->as_error()->get_error_message() );
	}
	return $response->get_data();
}

foreach ( $families as $family ) {
	// Idempotente: apaga a família anterior com o mesmo slug (e as faces dela) antes de recriar.
	foreach ( get_posts( array( 'post_type' => 'wp_font_family', 'name' => $family['slug'], 'post_status' => 'any', 'numberposts' => -1 ) ) as $old ) {
		foreach ( get_children( array( 'post_parent' => $old->ID, 'post_type' => 'wp_font_face' ) ) as $face ) {
			wp_delete_post( $face->ID, true );
		}
		wp_delete_post( $old->ID, true );
	}

	$created = spw_rest( 'POST', '/wp/v2/font-families', array(
		'font_family_settings' => wp_json_encode( array(
			'name'       => $family['name'],
			'slug'       => $family['slug'],
			'fontFamily' => $family['fontFamily'],
		) ),
	) );

	foreach ( $family['faces'] as $face ) {
		$target = trailingslashit( $font_dir['path'] ) . $face['file'];
		if ( ! copy( '/fonts-src/' . $face['file'], $target ) ) {
			WP_CLI::error( "não copiei {$face['file']}" );
		}
		spw_rest( 'POST', "/wp/v2/font-families/{$created['id']}/font-faces", array(
			'font_face_settings' => wp_json_encode( array(
				'fontFamily' => $family['fontFamily'],
				'fontStyle'  => 'normal',
				'fontWeight' => $face['fontWeight'],
				'src'        => trailingslashit( $font_dir['url'] ) . $face['file'],
			) ),
		) );
	}
	WP_CLI::log( "fonte registrada: {$family['name']} (" . count( $family['faces'] ) . ' arquivo(s))' );
}
WP_CLI::success( 'biblioteca de fontes pronta em ' . $font_dir['url'] );
