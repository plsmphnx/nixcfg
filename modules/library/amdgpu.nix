{ config, lib, ... }: let
  cfg = config.hardware.amdgpu;
in with lib; {
  options.hardware.amdgpu = {
    performanceLevel = mkOption {
      type = types.nullOr types.str;
      default = if (cfg.powerProfile != null) then "manual" else null;
      defaultText = literalExpression ''
        if (config.hardware.amdgpu.powerProfile != null) then "manual" else null
      '';
      description = "Force AMDGPU performance level.";
    };

    powerProfile = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 2;
      description = "Set AMDGPU power profile level.";
    };
  };

  config = let
    udev = key: val: ''
      ACTION=="add", SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{${key}}="${val}"
    '';
  in mkIf (cfg.performanceLevel != null || cfg.powerProfile != null) {
    services.udev.extraRules = optionalString (cfg.performanceLevel != null) (
      udev "device/power_dpm_force_performance_level" cfg.performanceLevel
    ) + optionalString (cfg.powerProfile != null) (
      udev "device/pp_power_profile_mode" (toString cfg.powerProfile)
    );
  };
}
