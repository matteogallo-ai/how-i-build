#!/usr/bin/env bash
# Fails if a GitHub pull request, commit or file linked from the Markdown files does not
# exist. It asks the GitHub API, which answers 404 for a missing object, rather than
# fetching the page. Non-GitHub and relative links are not checked.
set -euo pipefail
cd "$(dirname "$0")/.."

fail=0
links=$(grep -ohE 'https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/(pull/[0-9]+|commit/[0-9a-f]{7,40}|blob/[0-9a-f]{40}/[^)]+)' ./*.md | sort -u)
[ -n "$links" ] || { echo "no links found" >&2; exit 1; }

while read -r url; do
  path=${url#https://github.com/}
  repo=$(cut -d/ -f1-2 <<<"$path"); kind=$(cut -d/ -f3 <<<"$path"); rest=$(cut -d/ -f4- <<<"$path")
  case $kind in
    pull)   api="repos/$repo/pulls/$rest" ;;
    commit) api="repos/$repo/commits/$rest" ;;
    blob)   api="repos/$repo/contents/${rest#*/}?ref=${rest%%/*}" ;;
  esac
  if gh api "$api" --silent 2>/dev/null; then echo "ok   $url"; else echo "FAIL $url"; fail=1; fi
done <<<"$links"

exit $fail
