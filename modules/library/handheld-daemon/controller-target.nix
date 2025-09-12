{ config, lib, ... }: let
  cfg = config.services.handheld-daemon;
in with lib; {
  options.services.handheld-daemon.controllerTarget = mkOption {
    type = types.bool;
    description = "Add a user target tied to the Handheld Daemon Controller.";
  };

  config = mkIf (cfg.enable && cfg.controllerTarget) {
    services.udev.extraRules = ''
      KERNELS=="input[0-9]*", SUBSYSTEMS=="input", ATTRS{name}=="Handheld Daemon Controller", SYMLINK+="hhd", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="hhd.target"
    '';

    systemd.user.targets.hhd = {
      bindsTo = [ "dev-hhd.device" ];
      after   = [ "dev-hhd.device" "default.target" ];
    };
  };
}
