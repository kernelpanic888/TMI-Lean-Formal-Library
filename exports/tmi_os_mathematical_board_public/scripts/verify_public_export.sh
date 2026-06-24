#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

fail=0

say() {
  printf '%s\n' "$*"
}

require_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    say "EXPORT-CHECK FAIL: missing file: $path"
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
    say "EXPORT-CHECK FAIL: $label"
    say "$output"
    fail=1
  fi
}

say "TMI-OS export verification"

require_file "index.html"
require_file "TMI_OS_API.json"
require_file "TMI_OS_ADMIN.html"
require_file "TMI_OS_3D_TIME_ARTIFACT.html"
require_file "TMI_OS_MATHEMATICAL_BOARD.html"
require_file "TMI_OS_PROTECTED_MODEL_PAGE.html"
require_file "I1_MINI_LANGUAGE.md"
require_file "tmi_os_virtual_space_point.i1"
require_file "README_RU.md"
require_file "INSTALL_RU.md"
require_file "EXPORT_PROJECT_RU.md"
require_file "docs/TMI_OS_PUBLICATION_REFUSAL_CRITERIA_RU.md"

scan_paths=(
  "index.html"
  "tmi_os_virtual_space_point.i1"
  "README_RU.md"
  "INSTALL_RU.md"
  "EXPORT_PROJECT_RU.md"
  "docs"
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

if ! grep -q 'ProgrammingOnMathematics' index.html; then
  say "EXPORT-CHECK FAIL: site programming formula is missing from index.html"
  fail=1
fi

if ! grep -q 'DependencyChain(TMI-OS)' TMI_OS_MATHEMATICAL_BOARD.html; then
  say "EXPORT-CHECK FAIL: dependency chain is missing from board artifact"
  fail=1
fi

if ! grep -q 'SliceStack(B)' TMI_OS_3D_TIME_ARTIFACT.html; then
  say "EXPORT-CHECK FAIL: 3D time artifact slice stack is missing"
  fail=1
fi

if ! grep -q 'StaticAdminAPI' TMI_OS_ADMIN.html; then
  say "EXPORT-CHECK FAIL: admin API surface is missing"
  fail=1
fi

if ! grep -q '"NoServerUpload"' TMI_OS_API.json; then
  say "EXPORT-CHECK FAIL: static API guard is missing"
  fail=1
fi

if ! grep -q 'ProtectedPage :=' TMI_OS_PROTECTED_MODEL_PAGE.html; then
  say "EXPORT-CHECK FAIL: protected model page rule is missing"
  fail=1
fi

if ! grep -q 'small kernel now, grows in use' I1_MINI_LANGUAGE.md; then
  say "EXPORT-CHECK FAIL: I1 mini language kernel note is missing"
  fail=1
fi

if ! grep -q 'import Matrix : (Я)-Я-я' tmi_os_virtual_space_point.i1; then
  say "EXPORT-CHECK FAIL: canonical matrix import is missing from .i1 source"
  fail=1
fi

if [[ "$fail" -ne 0 ]]; then
  say "TMI-OS export verification: FAIL"
  exit 1
fi

say "TMI-OS export verification: PASS"
