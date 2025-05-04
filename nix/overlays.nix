{}: let
  props = builtins.fromJSON (builtins.readFile ../props.json);
in {
  sddm-lain-wired-theme = final: prev: {
    sddm-lain-wired-theme = final.libsForQt5.callPackage ./default.nix {
      version = props.version;
    };
  };
}
