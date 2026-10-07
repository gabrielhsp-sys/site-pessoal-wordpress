<?php
// Estilos globais do usuário com a identidade visual do GABRIEL.SYS (cores e tipografia de
// DESIGN.md / app/globals.css daquele repositório). Só recursos do WordPress: theme.json do
// usuário + CSS adicional dos estilos globais. Nenhum JavaScript.
// Roda via: scripts/wp.sh eval-file /scripts/global-styles.php
$font_url = trailingslashit( wp_get_font_dir()['url'] );

// Fundo do GABRIEL.SYS (app/globals.css, body e body::before): grade de 40px com linha branca a
// 1,8% e ruído fractal em SVG embutido (data: URI) a 3,5%, fixo e sem capturar clique. Só CSS.
// Pior caso de contraste com grade + ruído: corpo 8,45:1, navegação 6,06:1, sublinhado 3,76:1,
// linha de componente 3,13:1.
$background = <<<'CSS'
body{background:linear-gradient(90deg,transparent 0,transparent calc(100% - 1px),rgb(255 255 255 / .018) calc(100% - 1px)) 0 0/40px 40px,var(--wp--preset--color--base)}
body::before{position:fixed;inset:0;z-index:100;pointer-events:none;content:"";opacity:.035;background-image:url("data:image/svg+xml,%3Csvg viewBox='0 0 180 180' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.9' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='.35'/%3E%3C/svg%3E")}
CSS;

$styles = array(
	'version'                     => 3,
	'isGlobalStylesUserThemeJSON' => true,
	'settings'                    => array(
		'color'      => array(
			// Os slugs do tema ficam, para os blocos do Twenty Twenty-Five continuarem coerentes.
			'palette' => array(
				'theme'  => array(
					array( 'slug' => 'base', 'name' => 'Preto quente', 'color' => '#0c0b0a' ),
					array( 'slug' => 'contrast', 'name' => 'Marfim de tela', 'color' => '#e9e0ca' ),
					array( 'slug' => 'accent-1', 'name' => 'Âmbar de gravação', 'color' => '#f0ab3c' ),
					array( 'slug' => 'accent-2', 'name' => 'Âmbar de contato', 'color' => '#9f6421' ),
					array( 'slug' => 'accent-3', 'name' => 'Preto elevado', 'color' => '#151311' ),
					array( 'slug' => 'accent-4', 'name' => 'Marfim suave', 'color' => '#b8b09f' ),
					array( 'slug' => 'accent-5', 'name' => 'Preto de encaixe', 'color' => '#201d19' ),
					array( 'slug' => 'accent-6', 'name' => 'Linha de hardware', 'color' => '#6b6459' ),
				),
				'custom' => array(
					array( 'slug' => 'ivory-quiet', 'name' => 'Marfim quieto', 'color' => '#9b9487' ),
				),
			),
		),
		'typography' => array(
			'fontFamilies' => array(
				// Só as fontes da biblioteca: as do tema não são declaradas nem exportadas.
				'theme'  => array(),
				'custom' => array(
					array(
						'name'       => 'Bricolage Grotesque',
						'slug'       => 'bricolage-grotesque',
						'fontFamily' => '"Bricolage Grotesque", sans-serif',
						'fontFace'   => array(
							array( 'fontFamily' => 'Bricolage Grotesque', 'fontStyle' => 'normal', 'fontWeight' => '200 800', 'src' => array( $font_url . 'bricolage-grotesque-latin-wght-normal.woff2' ) ),
						),
					),
					array(
						'name'       => 'IBM Plex Mono',
						'slug'       => 'ibm-plex-mono',
						'fontFamily' => '"IBM Plex Mono", ui-monospace, monospace',
						'fontFace'   => array(
							array( 'fontFamily' => 'IBM Plex Mono', 'fontStyle' => 'normal', 'fontWeight' => '400', 'src' => array( $font_url . 'ibm-plex-mono-latin-400-normal.woff2' ) ),
							array( 'fontFamily' => 'IBM Plex Mono', 'fontStyle' => 'normal', 'fontWeight' => '600', 'src' => array( $font_url . 'ibm-plex-mono-latin-600-normal.woff2' ) ),
						),
					),
				),
			),
		),
	),
	'styles'                      => array(
		'color'      => array(
			'background' => 'var:preset|color|base',
			'text'       => 'var:preset|color|accent-4', // corpo em marfim suave (9.13:1)
		),
		'typography' => array(
			'fontFamily'    => 'var:preset|font-family|bricolage-grotesque',
			'fontSize'      => '1rem',
			'fontWeight'    => '400',
			'lineHeight'    => '1.55',
			'letterSpacing' => 'normal',
		),
		'elements'   => array(
			'heading' => array(
				'color'      => array( 'text' => 'var:preset|color|contrast' ),
				'typography' => array( 'fontFamily' => 'var:preset|font-family|bricolage-grotesque' ),
			),
			// h1 = "page-title" do GABRIEL.SYS.
			'h1'      => array(
				'typography' => array( 'fontSize' => 'clamp(2.5rem, 4.5vw, 3.5rem)', 'fontWeight' => '400', 'lineHeight' => '1', 'letterSpacing' => '-0.04em' ),
			),
			// h2 = "title" do GABRIEL.SYS; o respiro antes de cada subseção continua.
			'h2'      => array(
				'typography' => array( 'fontSize' => 'clamp(1.35rem, 2.2vw, 2rem)', 'fontWeight' => '600', 'lineHeight' => '1.15', 'letterSpacing' => 'normal' ),
				'spacing'    => array( 'margin' => array( 'top' => 'var:preset|spacing|50' ) ),
			),
			'link'    => array(
				'color'  => array( 'text' => 'var:preset|color|contrast' ),
				':hover' => array( 'color' => array( 'text' => 'var:preset|color|accent-1' ) ),
				':focus' => array( 'color' => array( 'text' => 'var:preset|color|accent-1' ) ),
			),
		),
		'blocks'     => array(
			// Marca: estilo "wordmark" (IBM Plex Mono 600, 14px, 0.08em).
			'core/site-title' => array(
				'color'      => array( 'text' => 'var:preset|color|contrast' ),
				'typography' => array( 'fontFamily' => 'var:preset|font-family|ibm-plex-mono', 'fontSize' => '0.875rem', 'fontWeight' => '600', 'letterSpacing' => '0.08em', 'textTransform' => 'uppercase' ),
			),
			// Navegação: estilo "label" (IBM Plex Mono 600, 11px, 0.04em, caixa alta), marfim quieto.
			'core/navigation' => array(
				'color'      => array( 'text' => 'var:preset|color|ivory-quiet' ),
				'typography' => array( 'fontFamily' => 'var:preset|font-family|ibm-plex-mono', 'fontSize' => '0.6875rem', 'fontWeight' => '600', 'letterSpacing' => '0.04em', 'textTransform' => 'uppercase' ),
			),
		),
		// O que o theme.json não expressa: cor do sublinhado, anel de foco, seleção, marcador.
		'css'        => 'a{text-decoration-thickness:1px;text-underline-offset:.24em;text-decoration-color:var(--wp--preset--color--accent-2)}'
			. 'a:hover{text-decoration-color:currentColor}'
			. ':focus-visible{outline:2px solid var(--wp--preset--color--accent-1);outline-offset:4px}'
			. '::selection{background:var(--wp--preset--color--accent-1);color:var(--wp--preset--color--base)}'
			. 'li::marker{color:var(--wp--preset--color--contrast)}'
			. '.wp-block-navigation a{text-decoration:none}'
			. '.wp-block-navigation a:hover,.wp-block-navigation .current-menu-item>a{color:var(--wp--preset--color--contrast)}'
			. '.wp-block-site-title a{text-decoration:none}'
			// Alvo mínimo de 44px (token "touch" do GABRIEL.SYS) na navegação, na marca e no botão do menu.
			. '.wp-block-navigation .wp-block-navigation-item__content,.wp-block-site-title a{min-height:44px;display:inline-flex;align-items:center}'
			. '.wp-block-navigation__responsive-container-open,.wp-block-navigation__responsive-container-close{min-width:44px;min-height:44px;display:inline-flex;align-items:center;justify-content:center}'
			. $background,
	),
);

$post_id = WP_Theme_JSON_Resolver::get_user_global_styles_post_id();
// Sem usuário logado (WP-CLI), o post nasce sem o termo do tema e o WordPress não o encontra.
wp_set_object_terms( $post_id, get_stylesheet(), 'wp_theme' );
$result = wp_update_post( array(
	'ID'           => $post_id,
	'post_content' => wp_slash( wp_json_encode( $styles ) ),
), true );
if ( is_wp_error( $result ) ) {
	WP_CLI::error( $result->get_error_message() );
}
wp_clean_theme_json_cache();
WP_CLI::success( "estilos globais gravados no post $post_id (identidade GABRIEL.SYS)" );
