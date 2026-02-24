{ config, lib, pkgs, ... }: let
  cfg = config.services.fan2go;
in with lib; {
  options.services.fan2go = {
    enable = mkEnableOption "the fan2go dynamic fan speed control daemon";
    package = mkPackageOption pkgs "fan2go" {};

    config = mkOption {
      type = types.attrs;
      default = {};
      description = "The fan2go configuration.";
    };
  };

  config = mkIf cfg.enable {
    environment = {
      etc."fan2go/fan2go.yaml".source =
        (pkgs.formats.yaml {}).generate "fan2go.yaml" cfg.config;

      systemPackages = [ cfg.package ];
    };

    systemd = {
      packages = [ cfg.package ];
      services.fan2go = {
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [
          config.environment.etc."fan2go/fan2go.yaml".source
        ];
      };
    };
  };
}
