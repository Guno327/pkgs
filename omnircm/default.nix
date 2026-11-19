{
  lib,
  stdenv,
  buildFHSEnv,
  fetchurl,
  makeDesktopItem,
  writeTextDir,
  nix-update-script,
}:
let
  version = "1.1.1";
  pname = "omnircm";

  arch =
    {
      x86_64-linux = "x64";
      aarch64-linux = "arm64";
    }
    .${stdenv.hostPlatform.system}
      or (throw "omnircm: unsupported system ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://github.com/DefenderOfHyrule/OmniRCM/releases/download/v${version}/OmniRCM-linux-${arch}";
    hash =
      {
        x64 = "sha256-voNweYkWf5StYdxVwnWXIhPI8N/mObXyNmH1EXVaIYY=";
        arm64 = "sha256-a7DNPWTYRMl8kKfP5fUb6c9elF/YfrMBu9pf7mPtGGw=";
      }
      .${arch};
    executable = true;
  };

  # Pinned separately so version bumps don't invalidate its hash
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/DefenderOfHyrule/OmniRCM/v1.1.1/Assets/icon.png";
    hash = "sha256-koJGy3Hi/HX7R3vEhzEawyXnvrEOZrSa9brQghXpP8Y=";
  };

  # Tegra X1 in RCM (APX) mode; uaccess grants the logged-in seat user access
  udevRules = writeTextDir "lib/udev/rules.d/70-omnircm.rules" ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0955", ATTRS{idProduct}=="7321", MODE="0660", TAG+="uaccess"
  '';

  desktopItem = makeDesktopItem {
    name = "omnircm";
    exec = "omnircm";
    icon = "omnircm";
    type = "Application";
    comment = "Nintendo Switch RCM payload injector";
    desktopName = "OmniRCM";
    categories = [ "Utility" ];
  };
in
buildFHSEnv {
  inherit pname version;

  # Self-contained .NET single-file + Avalonia; bundled native libs
  # (Skia, HarfBuzz, libusb) need these at runtime
  targetPkgs =
    pkgs: with pkgs; [
      icu
      openssl
      zlib
      krb5
      systemdLibs
      fontconfig
      freetype
      libGL
      vulkan-loader
      libx11
      libx11
      libxcursor
      libxext
      libxext
      libxi
      libxi
      libxrandr
      libice
      libsm
      libx11
      libxext
      libxtst
      libxi
      libxrender
      libxrandr
      libxcursor
      libxrender
    ];

  profile = ''
    export DOTNET_BUNDLE_EXTRACT_BASE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/omnircm"
  '';

  runScript = "${src}";

  extraInstallCommands = ''
    install -m 444 -D ${desktopItem}/share/applications/omnircm.desktop $out/share/applications/omnircm.desktop
    install -m 444 -D ${icon} $out/share/pixmaps/omnircm.png
    install -m 444 -D ${udevRules}/lib/udev/rules.d/70-omnircm.rules $out/lib/udev/rules.d/70-omnircm.rules
  '';

  passthru = {
    inherit src;
    updateScript = nix-update-script { };
  };

  meta = {
    mainProgram = "omnircm";
    description = "Nintendo Switch RCM payload injector";
    homepage = "https://github.com/DefenderOfHyrule/OmniRCM";
    downloadPage = "https://github.com/DefenderOfHyrule/OmniRCM/releases";
    changelog = "https://github.com/DefenderOfHyrule/OmniRCM/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
