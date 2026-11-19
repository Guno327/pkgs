{
  pkgs ?
    let
      n = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    in
    import (fetchTarball {
      url = "https://github.com/${n.owner}/${n.repo}/archive/${n.rev}.tar.gz";
      sha256 = n.narHash;
    }) { },
  ...
}:
let
  lib = pkgs.lib;
  dirs = lib.filterAttrs (
    name: type: type == "directory" && builtins.pathExists (./. + "/${name}/default.nix")
  ) (builtins.readDir ./.);
in
lib.mapAttrs (name: _: pkgs.callPackage (./. + "/${name}") { }) dirs
