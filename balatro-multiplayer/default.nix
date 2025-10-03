{
  lib,
  appimageTools,
  fetchurl,
  makeDesktopItem,
  nix-update-script,
}: let
  version = "1.0";
  pname = "balatro-multiplayer";

  src = fetchurl {
    url = "https://github.com/Balatro-Multiplayer/Balatro-Multiplayer-Launcher/releases/latest/download/balatro-multiplayer-launcher.AppImage";
    sha256 = "sha256-jJWAZq2gcmNn8GjfxMpdYcSQysoWGPqnPerScVDETGA=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

  desktopItem = makeDesktopItem {
    name = "balatro-multiplayer";
    exec = "balatro-multiplayer";
    type = "Application";
    comment = "Multiplayer launcher for balatro";
    desktopName = "Balatro Multiplayer";
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;
    extraInstallCommands = ''
      install -m 444 -D ${desktopItem}/share/applications/balatro-multiplayer.desktop $out/share/applications/balatro-multiplayer.desktop
    '';

    passthru.updateScript = nix-update-script {};

    meta = {
      homepage = "https://balatromp.com/";
      downloadPage = "https://balatromp.com/docs/getting-started/installation";
      license = lib.licenses.gpl3;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      platforms = ["x86_64-linux"];
    };
  }
