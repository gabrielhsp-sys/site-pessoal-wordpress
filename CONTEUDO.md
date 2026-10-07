# Conteúdo do site pessoal — APROVADO pelo Gabriel em 2026-10-06

Modelo: "Criação do conteúdo de seu website pessoal" (DCE701 Programação Web, UNIFAL-MG).
Fonte dos fatos: respostas do Gabriel (2026-10-06) e o site GABRIEL.SYS
(`lib/site.ts`, `app/about/page.tsx`, `content/public/*.mdx`).

Páginas e menu principal, nesta ordem: Início · Passatempos · Trabalho e estudo ·
Formação acadêmica · Contato.

---

## Página: Início

### Gabriel Henrique

Imagem: `profile.jpg` (do GABRIEL.SYS). Texto alternativo: "Gabriel Henrique ao lado de
uma mascote amarela em uma feira".

Sou estudante de Ciência da Computação na UNIFAL-MG, em Alfenas, e estou no 4º período
em 2026/2. Comecei quebrando e consertando o Windows, e a curiosidade ficou: entender
sistemas, escrever software e montar a infraestrutura onde ele roda. Hoje mantenho
projetos que passam por Java, C++, Linux, Docker, redes e interfaces, e procuro estágio.

---

## Página: Passatempos

### Jogar

Gosto de jogos competitivos, como o Valorant.

### Desenvolver ferramentas úteis para mim

Boa parte do que eu programo nasce de uma necessidade minha. Alguns exemplos:

- um site para a minha academia, em andamento;
- o meu Obsidian.

### Brincar com sistemas operacionais

Gosto de mexer no sistema operacional até ele ficar do meu jeito:

- montar homelabs;
- modificar o sistema;
- otimizar o desempenho.

### Acompanhar promoções para montar um PC

Acompanhar canais de promoção para montar um PC dá trabalho: são centenas de mensagens
por dia. Por isso escrevi um serviço que lê esses canais por mim e só avisa quando a
oferta é a peça certa. Cada mensagem passa por estas etapas, em ordem:

1. leitura dos canais de promoção;
2. normalização do título;
3. pontuação de 0 a 100 contra a minha lista de desejos;
4. extração de preço, cupom, loja e link;
5. remoção de anúncios repetidos;
6. alerta no meu canal privado.

Fonte: `content/public/telegram-offers.mdx` do GABRIEL.SYS (bloco `<Flow>`, conteúdo público).

### Escrever guias técnicos em português

Transformei o meu próprio pós-instalação do Fedora em um guia de copiar e colar, em
português, com o caminho de volta de cada passo. O guia segue esta estrutura:

- Parte segura
  - plugins do dnf5 e RPM Fusion
  - codecs, firmware e drivers de GPU
  - Flatpak, snapshots e base para jogos
- Aviso antes da parte avançada
- Parte avançada
  - ajustes de kernel, memória, disco e rede
- Como desfazer

Fonte: `content/public/fedora-post-install.mdx`.

---

## Página: Trabalho e estudo

### UNIFAL-MG e o curso de Ciência da Computação

Curso o bacharelado em Ciência da Computação na Universidade Federal de Alfenas, em
Alfenas – MG. Estou no 4º período em 2026/2.

- Universidade Federal de Alfenas: https://www.unifal-mg.edu.br/portal/
- Departamento de Ciência da Computação: https://bcc.unifal-mg.edu.br/portal/

### Projetos pessoais

Projetos que mantenho fora das disciplinas, com o código aberto no GitHub:

- Telegram Offers — serviço em Python que lê canais de promoção e avisa quando a oferta
  é a peça certa: https://github.com/gabrielhsp-sys/telegram-offer-monitor
- Fedora pós-instalação — guia em português para deixar uma instalação limpa do
  Fedora 44 pronta para uso: https://github.com/gabrielhsp-sys/fedora-post-install
- Academic System — sistema de gestão acadêmica em Java, com controle de acesso por
  papéis: https://github.com/gabrielhsp-sys/academic-system
- GABRIEL.SYS — meu portfólio, um site estático em Next.js:
  https://gabrielhsp-sys.github.io/

### Repositório da faculdade

Guardo os trabalhos da graduação em um repositório organizado por período, disciplina e
trabalho: https://github.com/gabrielhsp-sys/faculdade-bcc

Um exemplo é o trabalho de banco de dados em C++, que organiza e manipula registros sem
biblioteca de banco pronta:
https://github.com/gabrielhsp-sys/faculdade-bcc/tree/main/1-periodo/dce794-aeds1-pratica/trabalhos/Controle_e_Estatisticas_de_Base_de_Dados

---

## Página: Formação acadêmica

### Ensino superior

Universidade Federal de Alfenas – UNIFAL-MG – Alfenas – MG
Bacharelado em Ciência da Computação, 2025 – 2028 (conclusão prevista)
Em 2026/2, cursando o 4º período.

### Ensino médio

Escola Estadual João Lourenço – Areado – MG
Ensino médio, concluído em 2024.

---

## Página: Contato

### E-mail

gabrielhspereira36@gmail.com

### Na universidade

No hall do prédio B da UNIFAL-MG.

### Outros contatos

- GitHub: https://github.com/gabrielhsp-sys
- LinkedIn: https://www.linkedin.com/in/gabrielhsp-dev/

### Endereço

Areado – MG

---

## Notas

- "Passatempos" 4 e 5 foram sugeridos a partir do GABRIEL.SYS e aprovados pelo Gabriel.
- Os elementos de estrutura pedidos pelo modelo:
  - lista não ordenada nos passatempos 2 e 3;
  - lista ordenada no passatempo 4;
  - lista aninhada no passatempo 5.
- "Universidade Federal de Alfenas" é o nome por extenso da sigla UNIFAL-MG.
- Os links externos foram testados em 2026-10-06 e responderam HTTP 200. O LinkedIn bloqueia
  robôs, com código 999, então não dá para testar por script. Ele vem do GABRIEL.SYS.
