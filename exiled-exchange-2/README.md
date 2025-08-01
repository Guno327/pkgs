# Exiled Exchange 2

This is a flake for Exiled Exchange 2.

Just add it to your NixOS `flake.nix` or home-manager:

```nix
inputs = {
  exiled-exchange-2.url = "github:guno327/exiled-exchange-2-flake";
  ...
}
```

## Packages

This flake exposes a single package, in your `configuration.nix` in the
`environment.systemPackages` add:

```nix
inputs.exiled-exchange-2.packages."${system}".exiled-exchange-2
```

then

```shell
$ sudo nixos-rebuild switch
$ exiled-exchange-2
```

## Known Issues

This is not an issue with the flake but a known limitation of overlay on linux.
Tiling window manager (i.e. hyprland) do not play well with wayland overlays. To
get around this limitaiton the creators of this software have included a
`--no-overlay` flag that will launch the electron app as a browser tab. If you
want to edit the included `.desktop` entry to launch with this by default (or
any other supported launch arguments) you can do somethings like this:

```nix
xdg.desktopEntries.exiled-exchange-2 = {
    name = "Exiled Exchange 2";
    exec = "exiled-exchange-2 --no-overlay --listen=127.0.0.1:5000";
    icon = "exiled-exchange-2";
    type = "Application";
    comment = "Path of Exile 2 overlay program for price checking";
};
```
