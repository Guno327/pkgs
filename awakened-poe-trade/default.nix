{
  lib,
  appimageTools,
  fetchurl,
  makeDesktopItem,
  nix-update-script,
}: let
  version = "3.26.101";
  pname = "awakened-poe-trade";

  src = fetchurl {
    url = "https://github.com/SnosMe/awakened-poe-trade/releases/download/v${version}/Awakened-PoE-Trade-${version}.AppImage";
    sha256 = "sha256-n7xweAHNYQSDQMxZpHEf60PZk62ydwMsW9a7k3QeU1E=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

  desktopItem = makeDesktopItem {
    name = "awakened-poe-trade";
    exec = "awakened-poe-trade";
    icon = "awakened-poe-trade";
    type = "Application";
    comment = "Path of Exile overlay program for price checking";
    desktopName = "Awakened PoE Trade";
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;
    extraInstallCommands = ''
      install -m 444 -D ${desktopItem}/share/applications/awakened-poe-trade.desktop $out/share/applications/awakened-poe-trade.desktop
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/awakened-poe-trade.png \
         $out/share/icons/hicolor/512x512/apps/awakened-poe-trade.png
    '';

    passthru.updateScript = nix-update-script {};

    meta = {
      description = "Path of Exile overlay program for price checking items, among many other loved features.";
      homepage = "https://github.com/SnosMe/awakened-poe-trade";
      downloadPage = "https://github.com/SnosMe/awakened-poe-trade/releases";
      license = lib.licenses.mit;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      platforms = ["x86_64-linux"];
    };
  }
