{ config, lib, ... }: let
  cfg = config.hardware.amdgpu;
in with lib; {
  options.hardware.amdgpu = {
    performanceLevel = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "low";
      description = "Force AMDGPU performance level.";
    };
  };

  config = let
    udev = key: val: ''
      ACTION=="add", SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{${key}}="${val}"
    '';
  in mkIf (cfg.performanceLevel != null) {
    services.udev.extraRules =
      udev "device/power_dpm_force_performance_level" cfg.performanceLevel;
  };
}
