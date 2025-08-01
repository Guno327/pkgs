{
  pkgs ? import <nixpkgs> {},
  makeDesktopItem,
  lib,
}: let
  version = "2.3.1";
  pname = "orca-slicer-nightly";

  src = pkgs.fetchurl {
    url = "https://github.com/SoftFever/OrcaSlicer/releases/download/nightly-builds/OrcaSlicer-Linux-flatpak_V${version}-dev_x86_64.flatpak";
    sha256 = "sha256-qq8flUEjPNUt4iWEGQlZ8AFWW6wD+x5t7Ls8wGxi1D0=";
  };

  desktopItem = makeDesktopItem {
    name = "orca-slicer-nightly";
    exec = "orca-slicer-nightly";
    type = "Application";
    comment = "Orca Slicer Nightly Build Flatpak Runner";
    desktopName = "Orca Slicer - Nightly";
  };
in
  pkgs.stdenv.mkDerivation {
    inherit pname version src;

    unpackPhase = "true"; # skip unpacking .flatpak

    nativeBuildInputs = [pkgs.flatpak pkgs.makeWrapper];

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/OrcaSlicer-Linux-flatpak_V${version}-dev_x86_64.flatpak

      install -m 444 -D ${desktopItem}/share/applications/orca-slicer-nightly.desktop $out/share/applications/orca-slicer-nightly.desktop

      cat > $out/bin/orca-slicer-nightly <<EOF
      #!${pkgs.stdenv.shell}
      set -e

      # Create user-local repo if needed
      FLATPAK_DIR=\$HOME/.local/share/flatpak
      mkdir -p \$FLATPAK_DIR

      # Install app if not already installed
      if ! flatpak info io.github.softfever.OrcaSlicer >/dev/null 2>&1; then
        flatpak install --user --noninteractive $out/OrcaSlicer-Linux-flatpak_V${version}-dev_x86_64.flatpak
      fi

      exec flatpak run io.github.softfever.OrcaSlicer "\$@"
      EOF

      chmod +x $out/bin/orca-slicer-nightly
    '';

    postFixup = ''
      wrapProgram $out/bin/orca-slicer-nightly \
        --prefix PATH : ${lib.makeBinPath [pkgs.flatpak]}

    '';

    meta = {
      description = "Runner for orca slicer nightly flatpak";
      license = pkgs.lib.licenses.gpl3Only;
    };
  }
