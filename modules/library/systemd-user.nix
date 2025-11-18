{ config, lib, ... }: let
  cfg = config.systemd.user;
in with lib; {
  options.systemd.user = {
    path = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "/run/wrappers/bin" "/run/current-system/sw/bin" ];
      description = "Default PATH entries for user units.";
    };

    devices = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = {};
      example = { hhd.name = "Handheld Daemon Controller"; };
      description = "User targets based on device ATTRS.";
    };
  };

  config = {
    systemd.user = {
      extraConfig = optionalString (cfg.path != []) ''
        DefaultEnvironment="PATH=${concatStringsSep ":" cfg.path}"
      '';

      targets = mapAttrs (tgt: _: {
        bindsTo = [ "dev-user-${tgt}.device" ];
        after   = [ "dev-user-${tgt}.device" "default.target" ];
      }) cfg.devices;
    };

    services.udev.extraRules = let
      udev = tgt: attr: let
        attrs = concatStringsSep ", "
          (mapAttrsToList (k: v: "ATTRS{${k}}==\"${v}\"") attr);
      in ''
        ${attrs}, SYMLINK+="user/${tgt}", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="${tgt}.target"
      '';
    in concatStrings (mapAttrsToList udev cfg.devices);
  };
}
