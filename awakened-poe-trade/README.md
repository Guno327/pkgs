# Awakened POE Trade

This is a flake for Awakened POE Trade.

Just add it to your NixOS `flake.nix` or home-manager:

```nix
inputs = {
  exiled-exchange-2.url = "github:guno327/awakened-poe-trade-flake";
  ...
}
```

## Packages

This flake exposes a single package, in your `configuration.nix` in the
`environment.systemPackages` add:

```nix
inputs.awakened-poe-trade.packages."${system}".awakened-poe-trade
```

then

```shell
$ sudo nixos-rebuild switch
$ awakened-poe-trade
```

## Known Issues

This is not an issue with the flake but a known limitation of overlay on linux.
Tiling window manager (i.e. hyprland) do not play well with wayland overlays. To
get around this limitaiton the creators of this software have included a
`--no-overlay` flag that will launch the electron app as a browser tab. If you
want to edit the included `.desktop` entry to launch with this by default (or
any other supported launch arguments) you can do somethings like this:

```nix
xdg.desktopEntries.awakened-poe-trade = {
  name = "Awakened Poe Trade";
  exec = "awakened-poe-trade --no-overlay --listen=127.0.0.1:5000";
  icon = "awakened-poe-trade";
  type = "Application";
  comment = "Path of Exile overlay program for price checking";
};
```
