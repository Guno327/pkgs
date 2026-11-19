{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hidapi,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "btd700ctl";
  version = "0-unstable-2026-05-25";

  src = fetchFromGitHub {
    owner = "guno327";
    repo = "btd700ctl";
    rev = "b61a4d852dd4c5ff1a77d64e2218186ea0d6e4e1";
    hash = "sha256-koD17Ymuo7lj4ciD4OO8RW2ZB0rgVaBrBMsYspwClPU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ hidapi ];

  postInstall = ''
    install -Dm644 $src/udev/99-btd700.rules \
      $out/lib/udev/rules.d/99-btd700.rules
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Unofficial Linux driver for the Sennheiser BTD 700 dongle";
    homepage = "https://github.com/guno327/btd700ctl";
    license = lib.licenses.lgpl21Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = lib.platforms.linux;
    mainProgram = "btd700ctl";
  };
})
