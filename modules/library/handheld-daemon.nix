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
  sts = {
    manual_edge = [ 40 45 50 55 60 65 70 80 90 ];
    manual_junction = [ 40 50 60 70 90 100 ];
  };
in with lib; {
  imports = [ ./handheld-daemon/adjustor.nix ];

  options.services.handheld-daemon = {
    config = mkOption {
      type = types.nullOr types.attrs;
      default = null;
      example = { tdp.qam.tdp = 15; };
      description = "Handheld Daemon configuration.";
    };

    controllerTarget = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Add a user target tied to the Handheld Daemon Controller.";
    };

    fan = {
      mode = mkOption {
        type = types.enum [ "disabled" "manual_edge" "manual_junction" ];
        default = "disabled";
        example = "manual_edge";
        description = "Handheld Daemon fan mode.";
      };

      sleep = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Disable custom fan curves during sleep.";
      };

      fn = mkOption {
        type = types.nullOr (types.functionTo types.float);
        default = null;
        example = literalString "t: t * t";
        description = "Function used to generate a custom fan curve.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.fan.mode != "disabled" || !cfg.fan.sleep;
        message = "The HHD fan sleep service requires a manual fan mode.";
      }
      {
        assertion = cfg.fan.mode != "disabled" || cfg.fan.fn == null;
        message = "The HHD fan function requires a manual fan mode.";
      }
    ];

    systemd = {
      services = mkMerge [
        (mkIf (cfg.config != null || cfg.fan.mode != "disabled") {
          handheld-daemon-set = svc (foldr recursiveUpdate (cfg.config or {}) [
            (if (cfg.fan.mode != "disabled") then {
              tdp.qam.fan.mode = cfg.fan.mode;
            } else {})
            (if (cfg.fan.fn != null) then {
              tdp.qam.fan.${cfg.fan.mode} = let
                max = (last sts.${cfg.fan.mode}) + 0.0;
              in lib.listToAttrs (map (temp: {
                name = "st${toString temp}";
                value = builtins.ceil (100.0 * (cfg.fan.fn (temp / max)));
              }) sts.${cfg.fan.mode});
            } else {})
          ]) {};
        })

        (mkIf cfg.fan.sleep {
          fan-sleep = svc { tdp.qam.fan.mode = "disabled"; } {
            wantedBy = [ "sleep.target" ];
            before   = [ "sleep.target" ];
          };
          fan-awake = svc { tdp.qam.fan.mode = cfg.fan.mode; } {
            wantedBy = [ "post-resume.target" ];
            after    = [ "post-resume.target" ];
          };
        })
      ];

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
