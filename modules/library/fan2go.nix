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

    # https://github.com/markusressel/fan2go/blob/master/fan2go.service
    systemd.services.fan2go = {
      description = "Advanced Fan Control program";
      after = [ "lm-sensors.service" ];
      serviceConfig = {
        LimitNOFILE = 8192;
        Environment = "DISPLAY=:0";
        ExecStart = "${getExe cfg.package} -c /etc/fan2go/fan2go.yaml --no-style";
        Restart = "always";
        RestartSec = "1s";
      };
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ config.environment.etc."fan2go/fan2go.yaml".source ];
    };
  };
}
