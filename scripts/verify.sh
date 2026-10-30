#!/usr/bin/env bash
# Verification script for the Free Author Newsletter Kit.
# Exits non-zero if any check fails.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() { echo "FAIL: $*" >&2; FAILURES=1; }
pass() { echo "ok: $*"; }
FAILURES=""

echo "== Free Author Newsletter Kit verification =="
echo

# 1. Required files exist
for f in LICENSE README.md index.html STATUS.md; do
  if [ -f "$f" ]; then pass "$f exists"; else fail "$f missing"; fi
done

for t in welcome-email release-announcement signup-ideas sending-calendar; do
  for ext in md html; do
    f="templates/$t.$ext"
    if [ -f "$f" ]; then pass "$f exists"; else fail "$f missing"; fi
  done
done

# 2. No forbidden workflows
if [ -d .github/workflows ]; then fail ".github/workflows must not exist"; else pass "no .github/workflows"; fi

# 3. LICENSE copyright line exact
if grep -qxF "Copyright (c) 2026 Asdale Dynamics, LLC" LICENSE; then pass "LICENSE has exact copyright line"; else fail "LICENSE missing exact copyright line"; fi

# 4. README credits Asdale Dynamics, LLC
if grep -q "Asdale Dynamics, LLC" README.md; then pass "README credits Asdale Dynamics, LLC"; else fail "README missing credit"; fi

# 5. HTML files credit Asdale Dynamics, LLC and are well-formed
python3 - "$ROOT" <<'PY'
import html.parser, sys, glob, os
root = sys.argv[1]
class W3(html.parser.HTMLParser):
    def __init__(self):
        super().__init__()
        self.errors = []
    def error(self, message):
        self.errors.append(message)

failures = []
for path in sorted(glob.glob(os.path.join(root, "templates", "*.html"))) + [os.path.join(root, "index.html")]:
    with open(path, encoding="utf-8") as fh:
        src = fh.read()
    if "Asdale Dynamics, LLC" not in src:
        failures.append(f"{os.path.relpath(path, root)}: missing Asdale Dynamics, LLC credit")
    parser = W3()
    try:
        parser.feed(src)
    except Exception as exc:
        failures.append(f"{os.path.relpath(path, root)}: parse exception {exc}")
    if parser.errors:
        failures.append(f"{os.path.relpath(path, root)}: parse errors {parser.errors[:3]}")
    print(f"ok: {os.path.relpath(path, root)} well-formed + credited")
if failures:
    for f in failures:
        print(f"FAIL: {f}", file=sys.stderr)
    sys.exit(1)
PY

# 6. No secret-like strings anywhere (scan content files only)
if grep -riE 'sk-[A-Za-z0-9]{20,}|api[_-]?key|secret[_-]?key|password|PRIVATE KEY|BEGIN RSA' --exclude-dir=.git --exclude=verify.sh LICENSE README.md index.html templates scripts >/dev/null 2>&1; then
  fail "possible secret/credential found in files"
else
  pass "no secrets or credentials detected"
fi

# 7. Markdown lint
if command -v markdownlint >/dev/null 2>&1; then
  if markdownlint --config .markdownlint.json templates/*.md README.md; then pass "markdownlint clean"; else fail "markdownlint reported issues"; fi
else
  echo "skip: markdownlint not installed"
fi

echo
if [ -n "${FAILURES:-}" ]; then
  echo "VERIFICATION FAILED"
  exit 1
fi
echo "VERIFICATION PASSED"
