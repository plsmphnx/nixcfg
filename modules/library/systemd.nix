{ config, lib, ... }: let
  cfg = config.systemd;
in with lib; {
  options.systemd = {
    user = {
      devices = mkOption {
        type = types.attrsOf (types.attrsOf types.str);
        default = {};
        example = { gamepad.phys = "usb-0000:c6:00.0-3.1/input0"; };
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

    wake.enable = mkEnableOption "system wake target";
  };

  config = {
    environment.extraInit = optionalString (cfg.user.umask != null) ''
      umask ${cfg.user.umask}
    '';

    systemd = {
      targets = mkIf cfg.wake.enable {
        wake = {
          wantedBy = [ "multi-user.target" ];
          conflicts = [ "sleep.target" ];
          before = [ "sleep.target" ];
        };
        suspend.onSuccess = [ "wake.target" ];
        hibernate.onSuccess = [ "wake.target" ];
        hybrid-sleep.onSuccess = [ "wake.target" ];
        suspend-then-hibernate.onSuccess = [ "wake.target" ];
      };

      services = mkIf (cfg.user.umask != null) {
        "user@".serviceConfig.UMask = "0${cfg.user.umask}";
      };

      user = {
        extraConfig = optionalString (cfg.user.env != {}) ''
          DefaultEnvironment=${concatStringsSep " "
            (mapAttrsToList (k: v: "\"${k}=${v}\"") cfg.user.env)}
        '';

        targets = mapAttrs (tgt: _: {
          bindsTo = [ "dev-user-${tgt}.device" ];
          after   = [ "dev-user-${tgt}.device" "default.target" ];
        }) cfg.user.devices;
      };
    };

    services.udev.extraRules = let
      udev = tgt: attr: let
        attrs = concatStringsSep ", "
          (mapAttrsToList (k: v: "ATTRS{${k}}==\"${v}\"") attr);
      in ''
        ${attrs}, SYMLINK+="user/${tgt}", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="${tgt}.target"
      '';
    in concatStrings (mapAttrsToList udev cfg.user.devices);
  };
}
