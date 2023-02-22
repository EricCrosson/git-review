#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

pull_request="${1:?Must specify pull request on which to operate}"

gh pr diff "$pull_request"
gh pr review "$pull_request"
gh pr merge --merge --delete-branch "$pull_request"
