{ config, lib, pkgs, ... }: let
  cfg = config.services.handheld-daemon;
  svc = cfg: sys: with lib; {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${getExe' pkgs.handheld-daemon "hhdctl"} set ${
        concatStringsSep " " (mapAttrsToListRecursive (p: v: let
          state = concatStringsSep "." p;
          value = if isBool v then boolToString v else toString v;
        in "${state}=${value}") cfg)
      }";
    };
  } // sys;
in with lib; {
  imports = [ ./handheld-daemon/adjustor.nix ];

  options.services.handheld-daemon = {
    config = mkOption {
      type = types.nullOr types.attrs;
      default = null;
      example = { tdp.qam.tdp = 15; };
      description = ''
        Handheld Daemon configuration.
      '';
    };

    fanSleep = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "manual_edge";
      description = ''
        Disable custom fan curves during sleep and reset them to this on resume.
      '';
    };

    controllerTarget = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Add a user target tied to the Handheld Daemon Controller.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      services = {
      } // optionalAttrs (cfg.config != null) {
        handheld-daemon-set = svc cfg.config {};
      } // optionalAttrs (cfg.fanSleep != null) {
        fan-sleep = svc { tdp.qam.fan.mode = "disabled"; } {
          wantedBy = [ "sleep.target" ];
          before   = [ "sleep.target" ];
        };
        fan-awake = svc { tdp.qam.fan.mode = cfg.fanSleep; } {
          wantedBy = [ "post-resume.target" ];
          after    = [ "post-resume.target" ];
        };
      };

      user.targets = mkIf cfg.controllerTarget {
        hhd = {
          bindsTo = [ "dev-hhd.device" ];
          after   = [ "dev-hhd.device" "default.target" ];
        };
      };
    };

    services.udev = mkIf cfg.controllerTarget {
      extraRules = ''
        KERNELS=="input[0-9]*", SUBSYSTEMS=="input", ATTRS{name}=="Handheld Daemon Controller", SYMLINK+="hhd", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="hhd.target"
      '';
    };
  };
}
