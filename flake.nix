{
  description = "My custom packages flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    packages."${system}" = {
      awakened-poe-trade = pkgs.callPackage ./awakened-poe-trade {};
      exiled-exchange-2 = pkgs.callPackage ./exiled-exchange-2 {};
      satisfactory-modeler = pkgs.callPackage ./satisfactory-modeler {};
      orca-slicer-nightly = pkgs.callPackage ./orca-slicer-nightly {};
    };
  };
}
