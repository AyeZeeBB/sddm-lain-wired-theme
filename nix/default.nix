{
  stdenvNoCC,
  lib,
  sddm,
  qtbase,
  qtsvg,
  qtquickcontrols2,
  qtgraphicaleffects,
  wrapQtAppsHook,
  version ? "git",
  themeConf ? ../theme.conf,
}:
stdenvNoCC.mkDerivation rec {
  pname = "sddm-lain-wired-theme";
  inherit version;

  dontBuild = true;

  src = lib.cleanSourceWith {
    filter = name: type:
      (builtins.match ".*(nix)" name) == null;
    src = lib.cleanSourceWith {
      filter = name: type: let
        basename = builtins.baseNameOf name;
      in
        (builtins.match "(flake\.lock)|(props\.json)" basename) == null;
      src = lib.cleanSource ../.;
    };
  };

  propagatedUserEnvPkgs = [
    sddm
    qtbase
    qtsvg
    qtgraphicaleffects
    qtquickcontrols2
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  installPhase = ''
    local installDir=$out/share/sddm/themes/${pname}
    mkdir -p $installDir
    cp -aR -t $installDir Main.qml metadata.desktop theme.conf

    # Applying theme
    cat "${themeConf}" > "$installDir/theme.conf"
  '';
}
