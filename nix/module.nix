inputs: {
  config,
  options,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption mapAttrsToList concatStrings boolToString types mkEnableOption mdDoc;

  # Config
  cfg = config.services.displayManager.sddm.lainWiredNix;
  mkTranslationOption = name: example:
    mkOption {
      default = "";
      inherit example;
      description = "Add a translation for ${name}.";
      type = types.str;
    };

  # Theme configuration generator
  mkThemeConf = settings: let
    configStrings =
      mapAttrsToList (name: value: "${name}=\"${
        if builtins.isString value
        then value
        else if builtins.isBool value
        then boolToString value
        else toString value
      }\"\n\n")
      settings;
  in
    concatStrings (["[General]\n\n"] ++ configStrings);

  # Theme configuration file after generation
  theme-conf-file =
    pkgs.writeText "sddm-lain-wired-theme.conf" (mkThemeConf
      cfg.settings);

  # Final Package
  defaultPackage = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    themeConf = "${theme-conf-file}";
  };
in {
  options.services.displayManager.sddm.lainWiredNix = {
    enable = mkEnableOption "Lain Wired Theme";

    package = mkOption {
      default = defaultPackage;
      description = mdDoc ''
        Yes
      '';
      type = types.path;
    };

    settings = {
      NoSettings = mkOption {
        default = false;
        example = false;
        description = ''
          frik
        '';
        type = types.path;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];
    services.displayManager.sddm.theme = "sddm-lain-wired-theme";
  };
}
