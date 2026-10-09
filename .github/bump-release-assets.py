"""Point every release-asset url in a formula at `tag`, with fresh sha256s.

Usage: bump-release-assets.py Formula/x.rb v1.2.3
Exits nonzero, leaving the file untouched, if any asset cannot be fetched.
"""
import hashlib
import re
import sys
import urllib.request

path, tag = sys.argv[1], sys.argv[2]
URL = re.compile(r'^(\s*)url "https://github\.com/([^/]+/[^/]+)/releases/download/[^/]+/([^"]+)"\s*$')
SHA = re.compile(r'^(\s*)sha256 "[^"]*"\s*$')
VERSION = re.compile(r'^(\s*)version "[^"]*"\s*$')

out, digest = [], None
for line in open(path).read().split("\n"):
    m = URL.match(line)
    if m:
        indent, repo, asset = m.groups()
        url = f"https://github.com/{repo}/releases/download/{tag}/{asset}"
        try:
            with urllib.request.urlopen(url, timeout=60) as r:
                digest = hashlib.sha256(r.read()).hexdigest()
        except Exception as e:
            sys.exit(f"{url}: {e}")
        out.append(f'{indent}url "{url}"')
        continue
    m = SHA.match(line)
    if m and digest:
        out.append(f'{m.group(1)}sha256 "{digest}"')
        digest = None
        continue
    m = VERSION.match(line)
    if m:
        out.append(f'{m.group(1)}version "{tag.lstrip("v")}"')
        continue
    out.append(line)

if digest:
    sys.exit("a release url had no sha256 line after it")
text = "\n".join(out)
if "PLACEHOLDER" in text:
    sys.exit("PLACEHOLDER left after rewrite")
open(path, "w").write(text)
