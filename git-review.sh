#!/usr/bin/env bash
#
# Review and merge PRs from your terminal
#
# Usage:
#  git-review <pr-number>
#
# Options:
#   <pr-number>    GitHub pull request number
#
# All flags and options are passed to "gh pr review".
#
# @example
# git review 1234

set -o errexit
set -o nounset
set -o pipefail

usage() {
  cat <<EOF

Usage:
 git-review <pr-number>

Options:
  <pr-number>    GitHub pull request number
EOF
}

# Parse arguments
pull_request=""
review_args=()

while [ "${1:-}" != "" ]; do
  case "$1" in
  -h | --help)
    usage
    exit 1
    ;;
  -*)
    review_args+=("$1")
    shift
    ;;
  *[!0-9]*)
    usage
    exit 1
    ;;
  *)
    pull_request="$1"
    shift # past value
    ;;
  esac
done

# Validate arguments
validation_errors=false

if [ -z "$pull_request" ]; then
  echo >&2 "Error: must supply <pr-number>"
  validation_errors=true
fi

if [ "$validation_errors" == true ]; then
  usage
  exit 1
fi

main() {
  gh pr diff "$pull_request"
  gh pr review "${review_args[@]}" "$pull_request"
  gh pr merge --merge --delete-branch "$pull_request"
}

main
