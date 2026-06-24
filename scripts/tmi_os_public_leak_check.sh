#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

fail=0

say() {
  printf '%s\n' "$*"
}

check_no_matches() {
  local label="$1"
  local pattern="$2"
  shift 2

  local output
  if output="$(rg -n --hidden --no-ignore-vcs -S "$pattern" "$@" 2>/dev/null || true)"; then
    if [[ -n "$output" ]]; then
      say "LEAK-CHECK FAIL: $label"
      say "$output"
      fail=1
    fi
  fi
}

check_path_is_ignored() {
  local path="$1"
  if ! git check-ignore -q "$path"; then
    say "LEAK-CHECK FAIL: expected ignored path is not ignored: $path"
    fail=1
  fi
}

public_paths=(
  ".gitignore"
  "README.md"
  "docs/TMI_OS_FIRST_PUBLIC_PROGRAM_RU.md"
  "docs/TMI_OS_INSTALL_RU.md"
  "docs/TMI_OS_LINKEDIN_PUBLICATION_RU.md"
  "docs/TMI_OS_PUBLICATION_REFUSAL_CRITERIA_RU.md"
  "docs/TMI_OS_PUBLIC_PASSPORT.md"
  "docs/TMI_OS_REPOSITORY_PROFILE.md"
  "programs/tmi_os_mathematical_board"
  "exports/tmi_os_mathematical_board_public"
  "plugins/tmi-os-mathematical-board"
  "scripts/tmi_os_public_leak_check.sh"
)

content_scan_paths=(
  ".gitignore"
  "README.md"
  "docs/TMI_OS_FIRST_PUBLIC_PROGRAM_RU.md"
  "docs/TMI_OS_INSTALL_RU.md"
  "docs/TMI_OS_LINKEDIN_PUBLICATION_RU.md"
  "docs/TMI_OS_PUBLICATION_REFUSAL_CRITERIA_RU.md"
  "docs/TMI_OS_PUBLIC_PASSPORT.md"
  "docs/TMI_OS_REPOSITORY_PROFILE.md"
  "programs/tmi_os_mathematical_board"
  "exports/tmi_os_mathematical_board_public/index.html"
  "exports/tmi_os_mathematical_board_public/tmi_os_virtual_space_point.i1"
  "exports/tmi_os_mathematical_board_public/README_RU.md"
  "exports/tmi_os_mathematical_board_public/INSTALL_RU.md"
  "exports/tmi_os_mathematical_board_public/EXPORT_PROJECT_RU.md"
  "exports/tmi_os_mathematical_board_public/docs"
  "plugins/tmi-os-mathematical-board/.codex-plugin/plugin.json"
  "plugins/tmi-os-mathematical-board/README_RU.md"
  "plugins/tmi-os-mathematical-board/assets"
  "plugins/tmi-os-mathematical-board/skills"
)

blocked_path_regex='(^CANONICAL_|^SELF_SYSTEM_|^docs/intelligence_|(^|/)\.env(\.|$)|(^|/)id_rsa|\.pem$|\.key$|\.p12$)'
blocked_content_regex='AUTHOR_PRIVATE_TERRAIN|NOT_FOR_PUBLICATION|DO_NOT_RELEASE|ROOT_LEVEL_PRIVATE|PRIVATE_FORK|PUBLICATION_HOLD|CANONICAL_AUTHOR|SELF_SYSTEM_PASSPORT|CANONICAL_AUTHOR_SELF_MODEL|docs/intelligence_1_0|life_claim|self_hosting|private terrain|внутренние проекты'
local_path_regex='/Users/|/private/|/var/folders/|/tmp/codex-|codex-clipboard'
secret_regex='gho_[A-Za-z0-9_]+|github_pat_[A-Za-z0-9_]+|glpat-[A-Za-z0-9_-]+|sk-[A-Za-z0-9_-]{20,}|BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY|password *=|token *=|api[_-]?key *='
personal_email_regex='kernelpanic888@gmail\.com'
claim_refusal_regex='passport *= *biological|passport *= *consciousness|passport *= *legal|diagram *= *proof|VirtualSpace *= *empirical universe|TimeTick *= *external absolute time'

say "TMI-OS public leak check"

check_path_is_ignored "CANONICAL_AUTHOR_SELF_MODEL.md"
check_path_is_ignored "SELF_SYSTEM_PASSPORT.md"
check_path_is_ignored "docs/intelligence_1_0/README.md"

staged_paths="$(git diff --cached --name-only || true)"
if [[ -n "$staged_paths" ]]; then
  while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    if [[ "$path" =~ $blocked_path_regex ]]; then
      say "LEAK-CHECK FAIL: blocked path staged: $path"
      fail=1
    fi
  done <<< "$staged_paths"
fi

check_no_matches "private markers in public paths" "$blocked_content_regex" "${content_scan_paths[@]}"
check_no_matches "local machine paths in public paths" "$local_path_regex" "${content_scan_paths[@]}"
check_no_matches "secret-like material in public paths" "$secret_regex" "${content_scan_paths[@]}"
check_no_matches "personal email in public paths" "$personal_email_regex" "${content_scan_paths[@]}"
check_no_matches "claim overreach in public paths" "$claim_refusal_regex" "${content_scan_paths[@]}"

if [[ "$fail" -ne 0 ]]; then
  say "TMI-OS public leak check: FAIL"
  exit 1
fi

say "TMI-OS public leak check: PASS"
