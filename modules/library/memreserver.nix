{ config, lib, pkgs, ... }: let
  cfg = config.services.memreserver;
  memreserver = pkgs.callPackage ../../packages/memreserver.nix {};
in with lib; {
  options.services.memreserver.enable =
    mkEnableOption "the memreserver AMD VRAM eviction helper";

  config.systemd = mkIf cfg.enable {
    packages = [ memreserver ];
    services.memreserver.wantedBy = [ "sleep.target" ];
  };
}
