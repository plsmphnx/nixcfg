{ config, lib, pkgs, ... }: let
  cfg = config.services.flatpak;
in with lib; {
  options.services.flatpak = {
    removeCapSysNice = mkOption {
      type = types.bool;
      default = config.programs.gamescope.capSysNice;
      defaultText = literalExpression "config.programs.gamescope.capSysNice";
      description = ''
        Remove cap_sys_nice from flatpak so it can be run under gamescope.
      '';
    };
  };

  config = mkIf (cfg.enable && cfg.removeCapSysNice) {
    security.wrappers.flatpak = {
      owner = "root";
      group = "root";
      source = lib.getExe pkgs.flatpak;
      capabilities = "cap_sys_nice-pie";
    };
  };
}
