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
  key = {
    edge = "manual_edge";
    tctl = "manual_junction";
  };
  sts = {
    edge = [ 40 45 50 55 60 65 70 80 90 ];
    tctl = [ 40 50 60 70 90 100 ];
  };
in with lib; {
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
        type = types.nullOr (types.enum [ "edge" "tctl" ]);
        default = null;
        example = "edge";
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
        assertion = cfg.fan.mode != null || !cfg.fan.sleep;
        message = "The HHD fan sleep service requires a manual fan mode.";
      }
      {
        assertion = cfg.fan.mode != null || cfg.fan.fn == null;
        message = "The HHD fan function requires a manual fan mode.";
      }
    ];

    systemd = {
      services = mkMerge [
        (mkIf (cfg.config != null || cfg.fan.mode != null) {
          handheld-daemon-set = svc (foldr recursiveUpdate (cfg.config or {}) [
            (if (cfg.fan.mode != null) then {
              tdp.qam.fan.mode = key.${cfg.fan.mode};
            } else {})
            (if (cfg.fan.fn != null) then {
              tdp.qam.fan.${key.${cfg.fan.mode}} = lib.listToAttrs (map (temp: {
                name = "st${toString temp}";
                value = with builtins; elemAt (sort lessThan [0 (
                  ceil (100.0 * (cfg.fan.fn (temp / 100.0)))
                ) 100]) 1;
              }) sts.${cfg.fan.mode});
            } else {})
          ]) {};
        })

        (mkIf cfg.fan.sleep {
          fan-sleep = svc { tdp.qam.fan.mode = "disabled"; } {
            wantedBy = [ "sleep.target" ];
            before   = [ "sleep.target" ];
          };
          fan-awake = svc { tdp.qam.fan.mode = key.${cfg.fan.mode}; } {
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
