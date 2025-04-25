{ config, lib, ... }: let
  cfg = config.hibernate;
in with lib; {
  options.hibernate = {
    size = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 16;
      description = "RAM size for hibernation, in gigabytes.";
    };

    delay = mkOption {
      type = types.int;
      default = 30;
      example = 60;
      description = "Hibernation delay after suspend, in minutes.";
    };
  };

  config = mkIf (cfg.size != null) {
    swapDevices = [{
      device = "/swap";
      size = cfg.size * 1024;
    }];

    systemd = {
      sleep.extraConfig = ''
        HibernateDelaySec=${toString (cfg.delay * 60)}
        HibernateOnACPower=no
      '';
      tmpfiles.settings.hibernate = {
        "/sys/power/image_size".w.argument = toString (cfg.size * 1073741824);
      };
    };
  };
}
