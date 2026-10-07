# Configuração comum aos scripts. Nenhum segredo aqui: as senhas ficam em $SECRETS_DIR.
POD=spw
DB_VOLUME=spw-db
WP_VOLUME=spw-wp
SECRETS_DIR="$HOME/.config/site-pessoal-wordpress"
SITE_URL=http://127.0.0.1:8080
PUBLIC_URL=https://gabrielhsp-sys.github.io/site-pessoal-wordpress
# Imagens oficiais fixadas por digest (linux/amd64).
# wordpress:7.1.2-php8.4-apache · wordpress:cli-2.12.0-php8.4 · mariadb:11.8.9-noble
WP_IMAGE=docker.io/library/wordpress@sha256:2007075ffdfcdbf6cee457615658f2f02ed34722f0a599c2f80c43fbd0be31b3
CLI_IMAGE=docker.io/library/wordpress@sha256:668db37ba48bc8d8ec4ca2f22163a1c74d17216c97bf509e327168963a687117
DB_IMAGE=docker.io/library/mariadb@sha256:6422478cb8e159f080fb1d8ccf65101e26fe51385787fde7d16c3b165a331f15
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
