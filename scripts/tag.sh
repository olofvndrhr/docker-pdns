#!/usr/bin/env bash

set -eo pipefail

current_date="$(date +%Y%m%d)"

if [[ -z "${1}" || -z "${2}" ]]; then
    cat << EOF
usage:
-> ${0} <target> <tag>

targets:
    - rec   (recursor)
    - auth  (authoritative)
    - ls    (lightningstream)

example:
-> ${0} rec 1.1.1
EOF
fi

push_tag() {
    set -x
    local tag_name="${1}"
    git tag "${tag_name}" -m "${tag_name}"
    git push origin "${tag_name}"
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
