{ config, lib, pkgs, ... }: let
  cfg = config.services.handheld-daemon;
  svc = dir: tgt: cfg: with lib; {
    wantedBy = [ tgt ];
    ${dir} = [ tgt ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${getExe' pkgs.handheld-daemon "hhdctl"} set ${
        concatStringsSep " " (mapAttrsToListRecursive (p: v: let
          state = concatStringsSep "." p;
          value = if isBool v then boolToString v else toString v;
        in "${state}=${value}") cfg)
      }";
    };
  };
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
      paths = mkIf (cfg.config != null) {
        handheld-daemon-api = {
          wantedBy = [ "handheld-daemon.service" ];
          pathConfig = {
            PathChanged = "/run/hhd/api";
            Unit = "handheld-daemon-api.target";
          };
        };
      };

      targets = mkIf (cfg.config != null) {
        handheld-daemon-api = {};
      };

      services = {
      } // optionalAttrs (cfg.config != null) {
        handheld-daemon-config =
          svc "after" "handheld-daemon-api.target" cfg.config;
      } // optionalAttrs (cfg.fanSleep != null) {
        fan-sleep =
          svc "before" "sleep.target" { tdp.qam.fan.mode = "disabled"; };
        fan-awake = 
          svc "after" "post-resume.target" { tdp.qam.fan.mode = cfg.fanSleep; };
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
