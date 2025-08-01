# Orca Slicer Nightly Build

This is a flake for Orca Slicer Nightly Build.

Just add it to your NixOS `flake.nix` or home-manager:

```nix
inputs = {
  orca-slicer-nightly.url = "github:guno327/orca-slicer-nightly-flake";
  ...
}
```

## Packages

This flake exposes a single package, in your `configuration.nix` in the
`environment.systemPackages` add:

```nix
inputs.orca-slicer-nightly.packages."${system}".orca-slicer-nightly
```

then

```shell
$ sudo nixos-rebuild switch
$ orca-slicer-nightly
```

## IMPORTANT

This is beyond cursed. It is literally just a flatpak runner with a sha256
verified fetch of the release flatpak. No one should ever actually depend on
this.
