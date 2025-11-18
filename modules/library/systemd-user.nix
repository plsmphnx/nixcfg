{ config, lib, ... }: let
  cfg = config.systemd.user;
in with lib; {
  options.systemd.user = {
    devices = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = {};
      example = { hhd.name = "Handheld Daemon Controller"; };
      description = "User targets based on device ATTRS.";
    };

    env = mkOption {
      type = types.attrsOf types.envVar;
      default = {};
      example = { PATH = "/run/wrappers/bin:/run/current-system/sw/bin"; };
      description = "Default environment variables for user units.";
    };

    umask = mkOption {
      type = types.nullOr (types.strMatching "[0-9]{3}");
      default = null;
      example = "027";
      description = "Default umask for users.";
    };
  };

  config = {
    environment.extraInit = optionalString (cfg.umask != null) ''
      umask ${cfg.umask}
    '';

    systemd = {
      services = mkIf (cfg.umask != null) {
        "user@".serviceConfig.UMask = "0${cfg.umask}";
      };
      user = {
        extraConfig = optionalString (cfg.env != {}) ''
          DefaultEnvironment=${concatStringsSep " "
            (mapAttrsToList (k: v: "\"${k}=${v}\"") cfg.env)}
        '';

        targets = mapAttrs (tgt: _: {
          bindsTo = [ "dev-user-${tgt}.device" ];
          after   = [ "dev-user-${tgt}.device" "default.target" ];
        }) cfg.devices;
      };
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
