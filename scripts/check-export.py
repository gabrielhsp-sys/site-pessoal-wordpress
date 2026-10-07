#!/usr/bin/env python3
"""Confere o export em docs/: todo link e asset interno aponta para um arquivo que existe.

Uso: python3 -I scripts/check-export.py docs https://gabrielhsp-sys.github.io/site-pessoal-wordpress
"""
import html.parser
import json
import pathlib
import re
import sys
import urllib.parse

root = pathlib.Path(sys.argv[1])
base = sys.argv[2].rstrip("/") + "/"
base_path = urllib.parse.urlsplit(base).path


class Collector(html.parser.HTMLParser):
    def __init__(self):
        super().__init__()
        self.urls, self.in_importmap, self.importmap = [], False, ""
        self.in_style = False

    def handle_starttag(self, tag, attrs):
        a = dict(attrs)
        for key in ("href", "src"):
            if a.get(key):
                self.urls.append(a[key])
        if a.get("srcset"):
            self.urls += [part.strip().split()[0] for part in a["srcset"].split(",") if part.strip()]
        self.in_importmap = tag == "script" and a.get("type") == "importmap"
        self.in_style = tag == "style"

    def handle_data(self, data):
        if self.in_importmap:
            self.importmap += data
        if self.in_style:  # @font-face e outros url() em <style> inline
            data = re.sub(r"url\((\"data:[^\"]*\"|'data:[^']*')\)", "", data)  # SVG embutido tem url() interno
            self.urls += [u for u in re.findall(r"url\(['\"]?([^'\")]+)", data) if not u.startswith("data:")]

    def handle_endtag(self, tag):
        if tag == "style":
            self.in_style = False
        if tag == "script" and self.in_importmap:
            self.urls += list(json.loads(self.importmap).get("imports", {}).values())
            self.in_importmap, self.importmap = False, ""


def target(url):
    """Arquivo local para uma URL interna, ou None se a URL é externa."""
    parts = urllib.parse.urlsplit(url)
    if parts.scheme in ("mailto", "tel") or (parts.scheme and not url.startswith(base)):
        return None
    if not parts.scheme and not url.startswith("/"):
        return "relativa"
    path = urllib.parse.unquote(parts.path)
    if not path.startswith(base_path):
        return "fora-da-base"
    rel = path[len(base_path):]
    if rel == "" or rel.endswith("/"):
        rel += "index.html"
    return root / rel


errors, checked = [], 0
for page in sorted(root.rglob("*.html")):
    c = Collector()
    c.feed(page.read_text(encoding="utf-8"))
    urls = c.urls
    for css in [u for u in urls if urllib.parse.urlsplit(u).path.endswith(".css")]:
        t = target(css)
        if isinstance(t, pathlib.Path) and t.exists():
            for ref in re.findall(r"url\(['\"]?([^'\")]+)", t.read_text(encoding="utf-8")):
                if not ref.startswith("data:"):
                    urls.append(urllib.parse.urljoin(css, ref))
    text = page.read_text(encoding="utf-8")
    for url in urls:
        if url.startswith("#"):
            checked += 1
            if f'id="{url[1:]}"' not in text:
                errors.append(f"{page.relative_to(root)}: âncora {url} sem id correspondente")
            continue
        t = target(url)
        if t is None:
            continue
        checked += 1
        if not isinstance(t, pathlib.Path) or not t.exists():
            errors.append(f"{page.relative_to(root)}: {url} -> {t}")

print(f"referências internas conferidas: {checked}; quebradas: {len(errors)}")
for e in sorted(set(errors)):
    print("  QUEBRADA", e)
sys.exit(1 if errors else 0)
