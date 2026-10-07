#!/usr/bin/env python3
"""Confere que o <main> de cada página exportada tem exatamente os textos de content/pages.

Uso: python3 -I scripts/check-content.py   (na raiz do projeto)
"""
import html
import pathlib
import re
import sys

PAGES = {
    "01-inicio": "index.html",
    "02-passatempos": "passatempos/index.html",
    "03-trabalho-e-estudo": "trabalho-e-estudo/index.html",
    "04-formacao-academica": "formacao-academica/index.html",
    "05-contato": "contato/index.html",
}


def text(fragment):
    fragment = re.sub(r"<br\s*/?>", " ", fragment)
    fragment = re.sub(r"<(/?)(a|strong|em|code)\b[^>]*>", "", fragment)  # inline não separa
    fragment = re.sub(r"<[^>]+>", " ", fragment)
    return re.sub(r"\s+", " ", html.unescape(fragment)).strip()


def approved(source):
    source = re.sub(r"<!--.*?-->", "", source, flags=re.S)
    out = []
    # Texto próprio de cada bloco: para no início de uma lista aninhada ou no fechamento.
    for _, inner in re.findall(r"<(h2|p|li)\b[^>]*>((?:(?!<ul|<ol|<li|</li|</p>|</h2>).)*)", source, re.S):
        own = text(inner)
        if own:
            out.append(own)
    return out


total = missing = extra_pages = 0
for src, out in PAGES.items():
    exported = pathlib.Path("docs", out).read_text(encoding="utf-8")
    main = re.search(r"<main.*?</main>", exported, re.S).group(0)
    title = text(re.search(r"<h1[^>]*>(.*?)</h1>", main, re.S).group(1))
    main_text = text(main)
    want = approved(pathlib.Path("content/pages", src + ".html").read_text(encoding="utf-8"))
    rest = main_text
    for piece in sorted(want + [title], key=len, reverse=True):
        total += 1
        if piece not in rest:
            missing += 1
            print(f"AUSENTE {out}: {piece[:90]}")
        rest = rest.replace(piece, " ", 1)
    rest = re.sub(r"\s+", " ", rest).strip()
    if rest:
        extra_pages += 1
        print(f"TEXTO EXTRA {out}: {rest!r}")
    print(f"{out}: título={title!r}, trechos={len(want)}")

print(f"trechos conferidos: {total}; ausentes: {missing}; páginas com texto extra: {extra_pages}")
sys.exit(1 if missing or extra_pages else 0)
