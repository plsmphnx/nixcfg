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

    mode = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "shutdown";
      description = "Hibernation mode.";
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
      '' + optionalString (cfg.mode != null) ''
        HibernateMode=${cfg.mode}
      '';
      tmpfiles.settings.hibernate = {
        "/sys/power/image_size".w.argument = toString (cfg.size * 1073741824);
      } // optionalAttrs (cfg.mode != null) {
        "/sys/power/disk".w.argument = cfg.mode;
      };
    };
  };
}
