{ config, lib, pkgs, ... }: let
  cfg = config.services.memreserver;
  memreserver = pkgs.callPackage ../../packages/memreserver.nix {};
in with lib; {
  options.services.memreserver.enable =
    mkEnableOption "the memreserver AMD VRAM eviction helper";

  config = mkIf cfg.enable {
    systemd.services.memreserver = {
      serviceConfig = {
        Type = "oneshot";
        ExecStart = getExe memreserver;
      };
      wantedBy = [ "sleep.target" ];
      before = [ "sleep.target" ];
    };
  };
}
