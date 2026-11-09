#!/usr/bin/env bash
# Fails if a GitHub pull request, commit or file linked from the Markdown files does not
# exist. It asks the GitHub API, which answers 404 for a missing object, rather than
# fetching the page. Non-GitHub and relative links are not checked. For a file link, the
# pinned commit and the file are checked, not the #anchor: GitHub derives anchors from the
# rendered headings, and copying that rule here would be guesswork.
# Arguments: Markdown files to scan; default: the repo's top-level *.md.
set -euo pipefail
if [ $# -eq 0 ]; then cd "$(dirname "$0")/.." && set -- ./*.md; fi

fail=0
links=$(grep -ohE 'https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/(pull/[0-9]+|commit/[0-9a-f]{7,40}|blob/[0-9a-f]{40}/[^)]+)' "$@" | sort -u)
[ -n "$links" ] || { echo "no links found" >&2; exit 1; }

while read -r url; do
  # The anchor must go: left in the API path, it turns the ?ref=<sha> appended below into
  # part of the fragment, and the file is then read on the default branch.
  path=${url%%#*}; path=${path#https://github.com/}
  repo=$(cut -d/ -f1-2 <<<"$path"); kind=$(cut -d/ -f3 <<<"$path"); rest=$(cut -d/ -f4- <<<"$path")
  case $kind in
    pull)   api="repos/$repo/pulls/$rest" ;;
    commit) api="repos/$repo/commits/$rest" ;;
    blob)   api="repos/$repo/contents/${rest#*/}?ref=${rest%%/*}" ;;
  esac
  if gh api "$api" --silent 2>/dev/null; then echo "ok   $url"; else echo "FAIL $url"; fail=1; fi
done <<<"$links"

exit $fail
