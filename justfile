#!/usr/bin/env just --justfile

default: show_receipts

set shell := ["bash", "-uc"]
set dotenv-load := true

show_receipts:
    just --list

show_system_info:
    @echo "=================================="
    @echo "os : {{ os() }}"
    @echo "arch: {{ arch() }}"
    @echo "justfile dir: {{ justfile_directory() }}"
    @echo "invocation dir: {{ invocation_directory() }}"
    @echo "running dir: `pwd -P`"
    @echo "=================================="

test_shfmt:
    @echo "testing with shfmt"
    find . -type f \( -name "**.sh" -and -not -path "./.**" -and -not -path "./venv**" \) -exec shfmt -d -i 4 -bn -ci -sr "{}" \+;

format_shfmt:
    @echo "formatting with shfmt"
    find . -type f \( -name "**.sh" -and -not -path "./.**" -and -not -path "./venv**" \) -exec shfmt -w -i 4 -bn -ci -sr "{}" \+;

lint:
    @echo "linting project"
    just show_system_info
    just test_shfmt

format:
    @echo "formatting project project"
    just show_system_info
    just format_shfmt

check:
    just lint
    just format

tag *args:
    bash scripts/tag.sh {{ args }}

build-auth:
    @echo "building pdns-auth"
    cd auth && docker build . -f Dockerfile -t pdns-auth:test

build-rec:
    @echo "building pdns-rec"
    cd recursor && docker build . -f Dockerfile -t pdns-rec:test

build-ls:
    @echo "building pdns-ls"
    cd lightningstream && docker build . -f Dockerfile -t pdns-ls:test

build-dnsdist:
    @echo "building pdns-dnsdist"
    cd dnsdist && docker build . -f Dockerfile -t pdns-dnsdist:test
