#!/usr/bin/env bash
set -euo pipefail

# AZ-AUTH-00 is deliberately independent of the operator's shell profile.
# It fails closed when public authorship cannot be attributed to the canonical
# GitHub identity or when a forbidden technical coordinate is reachable.

readonly CANONICAL_NAME="kernelpanic888"
readonly CANONICAL_EMAIL="48477233+kernelpanic888@users.noreply.github.com"
readonly CANONICAL_REPOSITORY="kernelpanic888/TMI-Lean-Formal-Library"

# Split literals keep the gate from becoming the only blob that contains the
# coordinates it is designed to reject.
readonly FORBIDDEN_WORK_SLUG="osal""kutsan-godaddy"
readonly FORBIDDEN_WORK_EMAIL="osal""kutsan""@godaddy.com"
readonly FORBIDDEN_WORK_NOREPLY="99120669+osal""kutsan-godaddy""@users.noreply.github.com"
readonly FORBIDDEN_LEGACY_EMAIL="kernelpanic888""@gmail.com"
readonly FORBIDDEN_VALUES=(
  "$FORBIDDEN_WORK_SLUG"
  "$FORBIDDEN_WORK_EMAIL"
  "$FORBIDDEN_WORK_NOREPLY"
  "$FORBIDDEN_LEGACY_EMAIL"
)

fail() {
  printf 'AZ-AUTH-00 / FAIL / %s\n' "$*" >&2
  exit 1
}

pass() {
  printf 'AZ-AUTH-00 / PASS / %s\n' "$*"
}

contains_forbidden() {
  local value="$1"
  local forbidden
  for forbidden in "${FORBIDDEN_VALUES[@]}"; do
    if [[ "$value" == *"$forbidden"* ]]; then
      return 0
    fi
  done
  return 1
}

check_local_identity() {
  local name email signing_key commit_signing use_config_only remote_url

  name="$(git config --get user.name || true)"
  email="$(git config --get user.email || true)"
  signing_key="$(git config --get user.signingKey || true)"
  commit_signing="$(git config --bool --get commit.gpgSign || true)"
  use_config_only="$(git config --bool --get user.useConfigOnly || true)"
  remote_url="$(git remote get-url origin 2>/dev/null || true)"

  [[ "$name" == "$CANONICAL_NAME" ]] || fail "local user.name is not canonical"
  [[ "$email" == "$CANONICAL_EMAIL" ]] || fail "local user.email is not canonical"
  [[ -z "$signing_key" ]] || fail "a signing key is inherited by this repository"
  [[ -z "$commit_signing" || "$commit_signing" == "false" ]] || fail "automatic commit signing is enabled"
  [[ "$use_config_only" == "true" ]] || fail "user.useConfigOnly is not enabled"

  case "$remote_url" in
    "https://github.com/${CANONICAL_REPOSITORY}"|"https://github.com/${CANONICAL_REPOSITORY}.git"|"git@github.com:${CANONICAL_REPOSITORY}.git")
      ;;
    *)
      fail "origin does not point to the canonical repository"
      ;;
  esac

  contains_forbidden "$name $email $signing_key $remote_url" \
    && fail "a forbidden technical identity is active locally"

  pass "local identity and origin are canonical"
}

check_index() {
  local path

  while IFS= read -r path; do
    if contains_forbidden "$path"; then
      fail "an indexed path exposes a forbidden technical identity"
    fi
  done < <(git ls-files)

  if git grep --cached -I -Fq \
    -e "$FORBIDDEN_WORK_SLUG" \
    -e "$FORBIDDEN_WORK_EMAIL" \
    -e "$FORBIDDEN_WORK_NOREPLY" \
    -e "$FORBIDDEN_LEGACY_EMAIL" --; then
    fail "the index contains a forbidden technical coordinate"
  fi

  pass "index is free of forbidden technical coordinates"
}

check_commit_identity() {
  local commit="$1"
  local record author_name author_email committer_name committer_email

  record="$(git show -s --format='%an%x1f%ae%x1f%cn%x1f%ce' "$commit")"
  IFS=$'\x1f' read -r author_name author_email committer_name committer_email <<< "$record"

  [[ "$author_name" == "$CANONICAL_NAME" ]] \
    || fail "commit $commit has a non-canonical author name"
  [[ "$author_email" == "$CANONICAL_EMAIL" ]] \
    || fail "commit $commit has a non-canonical author email"

  if [[ "$committer_name" != "$CANONICAL_NAME" || "$committer_email" != "$CANONICAL_EMAIL" ]]; then
    [[ "$committer_name" == "GitHub" && "$committer_email" == "noreply@github.com" ]] \
      || fail "commit $commit has a non-canonical committer"
  fi

  contains_forbidden "$record" \
    && fail "commit $commit exposes a forbidden technical identity"

  if contains_forbidden "$(git show -s --format='%B' "$commit")"; then
    fail "commit $commit contains a forbidden coordinate in its message"
  fi
}

check_tag_identity() {
  local object_type ref_name tagger_name tagger_email tag_object

  while IFS=$'\t' read -r object_type ref_name tagger_name tagger_email; do
    contains_forbidden "$ref_name" \
      && fail "a tag name exposes a forbidden technical identity"

    [[ "$object_type" == "tag" ]] || continue
    [[ "$tagger_name" == "$CANONICAL_NAME" ]] \
      || fail "$ref_name has a non-canonical tagger name"
    [[ "$tagger_email" == "<$CANONICAL_EMAIL>" ]] \
      || fail "$ref_name has a non-canonical tagger email"

    tag_object="$(git rev-parse "$ref_name^{tag}")"
    if git cat-file tag "$tag_object" | LC_ALL=C grep -aFq \
      -e "$FORBIDDEN_WORK_SLUG" \
      -e "$FORBIDDEN_WORK_EMAIL" \
      -e "$FORBIDDEN_WORK_NOREPLY" \
      -e "$FORBIDDEN_LEGACY_EMAIL"; then
      fail "$ref_name contains a forbidden coordinate"
    fi
  done < <(git for-each-ref \
    --format='%(objecttype)%09%(refname)%09%(taggername)%09%(taggeremail)' \
    refs/tags)
}

check_reachable_content() {
  local object_list type_list oid path object_type
  object_list="$(mktemp "${TMPDIR:-/tmp}/az-auth-00-objects.XXXXXX")"
  type_list="$(mktemp "${TMPDIR:-/tmp}/az-auth-00-types.XXXXXX")"
  trap 'rm -f "${object_list:-}" "${type_list:-}"' EXIT

  git rev-list --objects --all > "$object_list"

  while IFS=' ' read -r oid path; do
    if contains_forbidden "${path:-}"; then
      fail "a reachable path exposes a forbidden technical identity"
    fi
  done < "$object_list"

  cut -d' ' -f1 "$object_list" \
    | git cat-file --batch-check='%(objectname) %(objecttype)' > "$type_list"

  while IFS=' ' read -r oid object_type; do
    [[ "$object_type" == "blob" ]] || continue
    if git cat-file blob "$oid" | LC_ALL=C grep -aFq \
      -e "$FORBIDDEN_WORK_SLUG" \
      -e "$FORBIDDEN_WORK_EMAIL" \
      -e "$FORBIDDEN_WORK_NOREPLY" \
      -e "$FORBIDDEN_LEGACY_EMAIL"; then
      fail "reachable blob $oid contains a forbidden technical coordinate"
    fi
  done < "$type_list"
}

check_history() {
  local commit ref_name

  while IFS= read -r ref_name; do
    contains_forbidden "$ref_name" \
      && fail "a reachable ref exposes a forbidden technical identity"
  done < <(git for-each-ref --format='%(refname)')

  while IFS= read -r commit; do
    check_commit_identity "$commit"
  done < <(git rev-list --all)

  check_tag_identity
  check_reachable_content
  pass "reachable history, refs, tags and blobs are canonical"
}

usage() {
  cat <<'USAGE'
Usage: scripts/az-auth-00.sh [--local] [--history]

With no arguments, both checks run. CI should use --history; local hooks use
both checks so a wrong operator identity is stopped before a commit exists.
USAGE
}

run_local=false
run_history=false

if [[ "$#" -eq 0 ]]; then
  run_local=true
  run_history=true
fi

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --local) run_local=true ;;
    --history) run_history=true ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; fail "unknown argument: $1" ;;
  esac
  shift
done

git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
  || fail "run the gate inside a Git worktree"

if [[ "$run_local" == true ]]; then
  check_local_identity
  check_index
fi
[[ "$run_history" == true ]] && check_history
