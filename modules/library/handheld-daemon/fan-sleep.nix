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
    type = types.bool;
    description = "Disable custom fan curves during sleep.";
  };

  config.systemd.services = mkIf (cfg.enable && cfg.fanSleep) {
    fan-sleep = fans "disabled" "before" "sleep.target";
    fan-awake = fans "manual_edge" "after" "post-resume.target";
  };
}
