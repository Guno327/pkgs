#! /usr/bin/env -S nix shell nixpkgs#nix-update nixpkgs#jq --command sh
set -e
nix-instantiate --eval --strict --json -E '
  let
    ps = import ./. {};
    args = u: builtins.tail (if builtins.isList u then u else u.command);
  in builtins.concatMap
    (n: if ps.${n} ? updateScript then [ ([ n ] ++ args ps.${n}.updateScript) ] else [ ])
    (builtins.attrNames ps)' \
| jq -r '.[] | @sh' | while read -r line; do
  eval "nix-update -f ./default.nix $line"
done
