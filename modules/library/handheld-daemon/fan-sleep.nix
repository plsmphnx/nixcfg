{ config, lib, pkgs, ... }: let
  cfg = config.services.handheld-daemon;

  fans = val: dir: tgt: let
    hhdctl = lib.getExe' pkgs.handheld-daemon "hhdctl";
  in {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${hhdctl} set tdp.qam.fan.mode=${val}";
    };
    wantedBy = [ tgt ];
    ${dir} = [ tgt ];
  };
in with lib; {
  options.services.handheld-daemon.fanSleep = mkOption {
    type = types.nullOr types.str;
    default = null;
    example = "manual_edge";
    description = ''
      Disable custom fan curves during sleep and reset them to this on resume.
    '';
  };

  config.systemd.services = mkIf (cfg.enable && cfg.fanSleep != null) {
    fan-sleep = fans "disabled" "before" "sleep.target";
    fan-awake = fans cfg.fanSleep "after" "post-resume.target";
  };
}
