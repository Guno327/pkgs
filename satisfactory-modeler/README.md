# Satisfactory Modeler

This is a flake for Satisfactor Modeler.

Just add it to your NixOS `flake.nix` or home-manager:

```nix
inputs = {
  satisfactory-modeler.url = "github:guno327/satisfactory-modeler-flake";
  ...
}
```

## Packages

This flake exposes a single package, in your `configuration.nix` in the
`environment.systemPackages` add:

```nix
inputs.satisfactory-modeler.packages."${system}".satisfactory-modeler
```

then

```shell
$ sudo nixos-rebuild switch
$ satisfactory-modeler
```

## Known Issues

Since I just pulled the precompiled binary from itch.io and made a wrapper for
it to run under nixos I cannot change where the executable attempts to
write/save files. As such you will get an error about trying to save your
preferences when exiting the application. So far this has not posed any issues
aside from persistance. I am working on seeing if I can force the file writes to
redirect to a writable directory, so stay tuned.
