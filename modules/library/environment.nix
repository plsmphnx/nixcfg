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

    environment.systemPackages = mkIf (cfg.alias != {}) [(
      pkgs.runCommandLocal "alias" { meta.priority = -1; } ''
        mkdir -p $out/bin
        ${concatStrings (mapAttrsToList (k: v: ''
          ln -s "${v}" "$out/bin/${k}"
        '') cfg.alias)}
      ''
    )];

    swapDevices = mkIf (cfg.swap > 0) [{
      device = "/swap";
      size = cfg.swap * 1024;
    }];

    systemd = mkIf cfg.hibernate.enable {
      sleep.extraConfig = concatStringsSep "\n"
        (mapAttrsToList (k: v: "Hibernate${k}=${v}") cfg.hibernate.options);

      services = mkIf (cfg.hibernate.workaround != []) {
        "hibernate-cycle-swap@" = {
          after = [ "post-resume.target" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = let
              swap = o: "${getExe' pkgs.util-linux.swap "swap${o}"} /%I";
            in [ (swap "off") (swap "on") ];
          };
        };
      } // (listToAttrs (map (path: {
        name = "hibernate-cycle-swap@${
          stringAsChars (c: if c == "/" then "-" else c) (removePrefix "/" path)
        }";
        value = {
          wantedBy = [ "post-resume.target" ];
          overrideStrategy = "asDropin";
        };
      }) cfg.hibernate.workaround));

      tmpfiles.settings.hibernate = {
        "/sys/power/image_size".w.argument =
          toString (cfg.swap * 1024 * 1024 * 1024);
      } // optionalAttrs (cfg.hibernate.options ? "Mode") {
        "/sys/power/disk".w.argument = cfg.hibernate.options.Mode;
      };
    };
  };
}
