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
  version = "0-unstable-2026-05-24";

  src = fetchFromGitHub {
    owner = "sobalap";
    repo = "btd700ctl";
    rev = "main";
    hash = "sha256-HWnDCH41JiOS50NGsDtfg4iLk/QcmycVvrknfByiGv4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hidapi
  ];

  postInstall = ''
    install -Dm644 $src/udev/99-btd700.rules \
      $out/lib/udev/rules.d/99-btd700.rules
  '';

  meta = {
    description = "Unofficial Linux driver for the Sennheiser BTD 700 dongle";
    homepage = "https://github.com/sobalap/btd700ctl";
    license = lib.licenses.lgpl21Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = lib.platforms.linux;
    mainProgram = "btd700d";
  };
})
