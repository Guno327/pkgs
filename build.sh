#! /usr/bin/env -S nix shell nixpkgs#jq --command sh
set -e
nix eval --json .#packages.x86_64-linux --apply builtins.attrNames \
| jq -r '.[] | ".#\(.)"' | xargs nix build --no-link
