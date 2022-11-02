#! /bin/sh

nix-env -i jq

nix build --json \
  | jq -r '.[].outputs | to_entries[].value' \
  | cachix push whslabs
