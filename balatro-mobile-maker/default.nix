{
  pkgs ? import <nixpkgs> {},
  fetchFromGitHub,
  nix-update-script,
}: let
  version = "0.8.3";
  pname = "balatro-mobile-maker";

  src = fetchFromGitHub {
    owner = "blake502";
    repo = "balatro-mobile-maker";
    rev = "beta-${version}";
    sha256 = "sha256-bV3iDpQ+JoNrKCeimxRL24OePeC1wjxk5I7U636IDvQ=";
  };
in
  pkgs.buildDotnetModule {
    inherit pname version src;
    projectFile = "balatro-mobile-maker/balatro-mobile-maker.csproj";
    passthru.updateScript = nix-update-script {};
  }
