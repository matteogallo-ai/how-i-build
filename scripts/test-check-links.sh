#!/usr/bin/env bash
# Runs check-links.sh on fixture Markdown files and checks its exit code. Needs `gh`,
# logged in: the cases ask the real GitHub API, like the check itself.
set -uo pipefail
cd "$(dirname "$0")"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
missing=0000000000000000000000000000000000000000
pinned=0ef7e9f380ba6d180e2c0e88ff8ee51e1ead4ad9
failures=0

# expect <want: pass|fail> <name> <link>
# A failure counts only if the script names this link: a non-zero exit alone would also
# come from a fixture the regex does not match, which would make the case a false green.
expect() {
  printf '[x](%s)\n' "$3" >"$tmp/case.md"
  if out=$(./check-links.sh "$tmp/case.md" 2>&1); then got=pass
  elif grep -qxF "FAIL $3" <<<"$out"; then got=fail
  else got="error: $out"; fi
  if [ "$got" = "$1" ]; then echo "ok   $2"; else echo "FAIL $2 (want $1, got $got)"; failures=1; fi
}

expect fail "missing commit, file link without anchor" \
  "https://github.com/matteogallo-ai/verity/blob/$missing/docs/results.md"
# An anchor once cut the ?ref= query off the API call, so the file was read on the
# default branch and the missing commit went unnoticed.
expect fail "missing commit, file link with anchor" \
  "https://github.com/matteogallo-ai/verity/blob/$missing/docs/results.md#open-issues"
expect fail "existing commit, missing file, with anchor" \
  "https://github.com/matteogallo-ai/verity/blob/$pinned/docs/no-such-file.md#x"
expect pass "existing commit and file, with anchor" \
  "https://github.com/matteogallo-ai/verity/blob/$pinned/docs/results.md#open-issues-what-the-numbers-do-not-say"

exit $failures
