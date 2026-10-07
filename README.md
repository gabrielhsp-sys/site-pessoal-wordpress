# Site pessoal em WordPress — Gabriel Henrique

Trabalho Prático #1 de DCE701 Programação Web (BCC/UNIFAL-MG, 2026/2).

O site é feito em WordPress, que roda localmente em Podman, e é publicado como site estático
no GitHub Pages. O export é gerado pelo plugin Simply Static.

- Site publicado: https://gabrielhsp-sys.github.io/site-pessoal-wordpress/
- Conteúdo aprovado: [`CONTEUDO.md`](CONTEUDO.md)
- Páginas em blocos Gutenberg: `content/pages/*.html`. É a fonte que o WordPress recebe.
- Export publicado: `docs/`. O GitHub Pages serve a pasta `main:/docs`.

## O que roda

| Peça | Versão | Fixada por |
|---|---|---|
| WordPress | 7.1.2, PHP 8.4, Apache | digest em `scripts/env.sh` |
| WP-CLI | 2.12.0, PHP 8.4 | digest em `scripts/env.sh` |
| MariaDB | 11.8.9 | digest em `scripts/env.sh` |
| Tema | Twenty Twenty-Five, o padrão do WordPress | — |
| Plugin | Simply Static 3.8.16 | zip oficial conferido pelos checksums do wordpress.org |
| Idioma | pt_BR | — |

Detalhes do ambiente local:

- O WordPress escuta só em `127.0.0.1:8080`, e o banco não é publicado no host.
- O banco e os arquivos do WordPress ficam nos volumes Podman `spw-db` e `spw-wp`.
- As senhas ficam fora do Git, em `~/.config/site-pessoal-wordpress/`, com permissão `600`:
  - `db.env` tem as senhas do banco;
  - `admin.env` tem o usuário, a senha e a URL do admin.

## Subir o WordPress local

1. `cd ~/Dev/projects/academic/site-pessoal-wordpress`
2. `scripts/up.sh`
3. Abra http://127.0.0.1:8080/ para ver o site.
4. Abra http://127.0.0.1:8080/wp-admin/ para entrar no admin. O login e a senha estão em `~/.config/site-pessoal-wordpress/admin.env`.

## Derrubar

1. `scripts/down.sh`

Esse comando só para o pod. Os volumes continuam intactos, e o próximo `scripts/up.sh` volta ao mesmo estado.

## Visual

O visual usa só recursos do tema:

- a variação de estilo **Noon**, com corpo em peso 400 e mais espaço antes de cada subseção;
- um template `page` com menos espaço vazio no topo;
- colunas no Início e na Formação.

Para reaplicar o visual:

1. `scripts/apply-style.sh`

## Editar o conteúdo

O fluxo recomendado mantém o Git como fonte:

1. Edite o arquivo da página em `content/pages/`.
2. `scripts/build-pages.sh`
3. Confira em http://127.0.0.1:8080/.

Também dá para editar pelo `wp-admin`. Nesse caso, copie o conteúdo de volta para `content/pages/`. Senão o próximo `scripts/build-pages.sh` sobrescreve a edição.

## Reexportar o site estático

1. `scripts/export.sh`
2. `grep -rnE "localhost|127\.0\.0\.1|:8080|Lorem" docs/`
3. `python3 -I scripts/check-export.py docs https://gabrielhsp-sys.github.io/site-pessoal-wordpress`
4. `python3 -I scripts/check-content.py`

O passo 2 não deve achar nada. Os passos 3 e 4 devem terminar com `exit 0`.

O `export.sh` faz o seguinte:

- configura o Simply Static para gravar em `export/`, com as URLs trocadas para o endereço público;
- restringe os crawlers à home e às páginas;
- tira do `<head>` os links para `xmlrpc.php` e os shortlinks `?p=N`;
- copia o resultado para `docs/` e cria `docs/.nojekyll`;
- liga `WP_HTTP_BLOCK_EXTERNAL` no `wp-config.php`: o WordPress local para de chamar serviços externos e só fala com o próprio site.

## Republicar

1. `git add docs content CONTEUDO.md`
2. `git commit -m "docs: atualiza o site exportado"`
3. `git push origin main`
4. `gh api repos/gabrielhsp-sys/site-pessoal-wordpress/pages/builds/latest --jq .status`

O build terminou quando o passo 4 mostrar `built`.

## Remover tudo do computador

Esta remoção apaga o banco e os arquivos do WordPress. Ela é irreversível.

1. `podman pod rm -f spw`
2. `podman volume rm spw-db spw-wp`
3. `rm -r ~/.config/site-pessoal-wordpress`

## Como foi montado do zero

Se os volumes forem apagados, `scripts/up.sh` recria o banco e as credenciais. A instalação
em si foi feita assim:

- `wp core install --locale=pt_BR`, com a senha do admin lida da entrada padrão;
- `wp language core install pt_BR --activate`;
- `wp plugin install` com o zip do Simply Static;
- remoção do conteúdo de exemplo, de Akismet e de Hello Dolly;
- comentários e pings desligados;
- links permanentes em `/%postname%/`;
- importação da foto, sem metadados, com `wp media import`;
- `scripts/build-pages.sh`;
- `scripts/apply-style.sh`.

O ID da foto, `5`, está fixo em `content/pages/01-inicio.html`. Numa reinstalação, confira o ID novo
com `scripts/wp.sh post list --post_type=attachment`.
