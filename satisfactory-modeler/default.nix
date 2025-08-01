{pkgs ? import <nixpkgs> {}}: let
  pname = "satisfactory-modeler";
  version = "1.6.0";
in
  pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = ./satisfactory-modeler.zip;

    nativeBuildInputs = [pkgs.unzip pkgs.makeWrapper];
    buildInputs = [
      pkgs.openjdk
      pkgs.freetype
      pkgs.fontconfig
      pkgs.xorg.libX11
      pkgs.xorg.libXext
      pkgs.xorg.libXtst
      pkgs.xorg.libXi
      pkgs.xorg.libXrender
      pkgs.xorg.libXrandr
      pkgs.xorg.libXcursor
      pkgs.noto-fonts
    ];

    unpackPhase = ''
      unzip $src -d source
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp -r source/* $out/

      chmod +x $out/satisfactory_modeler.sh

      makeWrapper $out/satisfactory_modeler.sh $out/bin/satisfactory-modeler \
        --set JAVA_HOME ${pkgs.openjdk} \
        --set FONTCONFIG_PATH ${pkgs.fontconfig}/etc/fonts \
        --prefix PATH : ${pkgs.openjdk}/bin \
        --run 'mkdir -p /tmp/satisfactory-modeler' \
        --set HOME /tmp/satisfactory-modeler \
        --add-flags "-Djava.io.tmpdir=/tmp/satisfactory-modeler" \
        --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath [
        pkgs.xorg.libX11
        pkgs.xorg.libXext
        pkgs.xorg.libXtst
        pkgs.xorg.libXi
        pkgs.xorg.libXrender
        pkgs.xorg.libXrandr
        pkgs.xorg.libXcursor
        pkgs.freetype
        pkgs.fontconfig
      ]}

      mkdir -p $out/share/applications
      cat > $out/share/applications/satisfactory-modeler.desktop <<EOF
      [Desktop Entry]
      Name=Satisfactory Modeler
      Comment=3D Model viewer for Satisfactory
      Exec=$out/bin/satisfactory-modeler
      Icon=$out/images/icons/Constructor.png
      Terminal=false
      Type=Application
      Categories=Graphics;Utility;
      EOF
    '';

    meta = {
      homepage = "https://satisfactorymodeler.itch.io/satisfactorymodeler";
      platforms = ["x86_64-linux"];
      description = "Model your Satisfactory builds";
      license = pkgs.lib.licenses.free; # Change if known
    };
  }
