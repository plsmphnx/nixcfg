{ config, lib, ... }: let
  cfg = config.hibernate;
in with lib; {
  options.hibernate = {
    size = mkOption {
      type = types.ints.unsigned;
      default = 0;
      example = 16;
      description = "RAM size for hibernation, in gigabytes.";
    };

    options = mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = { Mode = "shutdown"; };
      description = "Hibernate options; see {manpage}`sleep.conf.d(5)`.";
    };
  };

  config = mkIf (cfg.size > 0) {
    swapDevices = [{
      device = "/swap";
      size = cfg.size * 1024;
    }];

    systemd = {
      sleep.extraConfig = concatStringsSep "\n"
        (mapAttrsToList (k: v: "Hibernate${k}=${v}") cfg.options);
      
      tmpfiles.settings.hibernate = {
        "/sys/power/image_size".w.argument = toString (cfg.size * 1073741824);
      } // optionalAttrs (cfg.options ? "Mode") {
        "/sys/power/disk".w.argument = cfg.options.Mode;
      };
    };
  };
}
