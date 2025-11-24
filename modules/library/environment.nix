{ config, lib, pkgs, ... }: let
  cfg = config.environment;
in with lib; {
  options.environment = {
    alias = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Alias executables to other names.";
    };

    hibernate = {
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
  };

  config = {
    environment.systemPackages = mkIf (cfg.alias != {}) [(
      pkgs.runCommandLocal "alias" { meta.priority = -1; } ''
        mkdir -p $out/bin
        ${concatStrings (mapAttrsToList (k: v: ''
          ln -s "${v}" "$out/bin/${k}"
        '') cfg.alias)}
      ''
    )];

    swapDevices = mkIf (cfg.hibernate.size > 0) [{
      device = "/swap";
      size = cfg.hibernate.size * 1024;
    }];

    systemd = mkIf (cfg.hibernate.size > 0) {
      sleep.extraConfig = concatStringsSep "\n"
        (mapAttrsToList (k: v: "Hibernate${k}=${v}") cfg.hibernate.options);

      tmpfiles.settings.hibernate = {
        "/sys/power/image_size".w.argument =
          toString (cfg.hibernate.size * 1024 * 1024 * 1024);
      } // optionalAttrs (cfg.hibernate.options ? "Mode") {
        "/sys/power/disk".w.argument = cfg.hibernate.options.Mode;
      };
    };
  };
}
