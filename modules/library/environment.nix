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
      enable = mkEnableOption "hibernation";

      options = mkOption {
        type = types.attrsOf types.str;
        default = {};
        example = { Mode = "shutdown"; };
        description = "Hibernate options; see {manpage}`sleep.conf.d(5)`.";
      };

      workaround = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "/swap" ];
        description = "Cycle the listed swap locations after hibernate.";
      };
    };

    swap = mkOption {
      type = types.ints.unsigned;
      default = 0;
      example = 16;
      description = "Swap file size, in gigabytes.";
    };
  };

  config = {
    assertions = [{
      assertion = cfg.swap > 0 || !cfg.hibernate.enable;
      message = "Enabling hibernation requires a swap file.";
    }];

    environment = {
      systemPackages = mkIf (cfg.alias != {}) [(
        pkgs.runCommandLocal "alias" { meta.priority = -1; } ''
          mkdir -p $out/bin
          ${concatStrings (mapAttrsToList (k: v: ''
            ln -s "${v}" "$out/bin/${k}"
          '') cfg.alias)}
        ''
      )];

      etc = mkIf (cfg.hibernate.workaround != []) {
        "systemd/system-sleep/hibernate-cycle-swap.sh".source = let
          swap = o: "${getExe' pkgs.util-linux.swap "swap${o}"}";
        in pkgs.writeScript "hibernate-cycle-swap" ''
          #!/bin/sh
          if [ $1 = post ] && [ $SYSTEMD_SLEEP_ACTION = hibernate ]; then

          ${concatStringsSep "\n" (map (s: ''
            systemd-cat -t hibernate-cycle-swap echo 'Cycling ${s}'
            ${swap "off"} ${s}
            ${swap "on"} ${s}
          '') cfg.hibernate.workaround)}
          fi
        '';
      };
    };

    swapDevices = mkIf (cfg.swap > 0) [{
      device = "/swap";
      size = cfg.swap * 1024;
    }];

    systemd = mkIf cfg.hibernate.enable {
      sleep.extraConfig = concatStringsSep "\n"
        (mapAttrsToList (k: v: "Hibernate${k}=${v}") cfg.hibernate.options);

      tmpfiles.settings.hibernate = {
        "/sys/power/image_size".w.argument =
          toString (cfg.swap * 1024 * 1024 * 1024);
      } // optionalAttrs (cfg.hibernate.options ? "Mode") {
        "/sys/power/disk".w.argument = cfg.hibernate.options.Mode;
      };
    };
  };
}
