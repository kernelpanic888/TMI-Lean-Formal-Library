#!/usr/bin/env bash
set -euo pipefail

plugin_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$plugin_root"

fail=0

say() {
  printf '%s\n' "$*"
}

require_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    say "PLUGIN-CHECK FAIL: missing file: $path"
    fail=1
  fi
}

check_no_matches() {
  local label="$1"
  local pattern="$2"
  shift 2

  local output
  output="$(grep -RInE "$pattern" "$@" 2>/dev/null || true)"
  if [[ -n "$output" ]]; then
    say "PLUGIN-CHECK FAIL: $label"
    say "$output"
    fail=1
  fi
}

say "TMI-OS mathematical board plugin verification"

require_file ".codex-plugin/plugin.json"
require_file "README_RU.md"
require_file "assets/index.html"
require_file "assets/tmi_os_virtual_space_point.i1"
require_file "assets/EXPORT_PROJECT_RU.md"
require_file "skills/tmi-os-mathematical-board/SKILL.md"
require_file "scripts/preview_board.sh"

scan_paths=(
  ".codex-plugin/plugin.json"
  "README_RU.md"
  "assets"
  "skills"
)

check_no_matches \
  "local machine paths" \
  '/Users/|/private/|/var/folders/|codex-clipboard' \
  "${scan_paths[@]}"

check_no_matches \
  "private/internal markers" \
  'CANONICAL_AUTHOR|SELF_SYSTEM_PASSPORT|docs/intelligence_1_0|AUTHOR_PRIVATE_TERRAIN|NOT_FOR_PUBLICATION|DO_NOT_RELEASE|PRIVATE_FORK|PUBLICATION_HOLD|внутренние проекты' \
  "${scan_paths[@]}"

check_no_matches \
  "secret-like material" \
  'gho_[A-Za-z0-9_]+|github_pat_[A-Za-z0-9_]+|glpat-[A-Za-z0-9_-]+|sk-[A-Za-z0-9_-]{20,}|BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY|password *=|token *=|api[_-]?key *=' \
  "${scan_paths[@]}"

check_no_matches \
  "claim overreach" \
  'passport *= *biological|passport *= *consciousness|passport *= *legal|diagram *= *proof|VirtualSpace *= *empirical universe|TimeTick *= *external absolute time' \
  "${scan_paths[@]}"

if ! grep -q 'DependencyChain(TMI-OS)' assets/index.html; then
  say "PLUGIN-CHECK FAIL: dependency chain is missing from assets/index.html"
  fail=1
fi

if ! grep -q 'import Matrix : (Я)-Я-я' assets/tmi_os_virtual_space_point.i1; then
  say "PLUGIN-CHECK FAIL: canonical matrix import is missing from .i1 source"
  fail=1
fi

if [[ "$fail" -ne 0 ]]; then
  say "TMI-OS mathematical board plugin verification: FAIL"
  exit 1
fi

say "TMI-OS mathematical board plugin verification: PASS"
