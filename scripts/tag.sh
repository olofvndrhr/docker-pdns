#!/usr/bin/env bash

set -xeuo pipefail

current_date="$(date +%Y%m%d)"

push_tag() {
    local tag_name="${1}"
    git tag --force "${tag_name}" -m "${tag_name}"
    git push --force origin "${tag_name}"
}

case "${1}" in
    "rec" | "recursor")
        push_tag "rec-${2}+${current_date}"
        ;;
    "auth" | "authoritative")
        push_tag "auth-${2}+${current_date}"
        ;;
    "ls" | "lightningstream")
        push_tag "ls-${2}+${current_date}"
        ;;
esac
