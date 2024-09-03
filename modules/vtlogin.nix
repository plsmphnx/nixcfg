{ config, lib, pkgs, ... }: let
  vtwait = pkgs.writeCBin "vtwait"
    (builtins.readFile ../tools/vtwait.c);
in with lib; {
  options.vtlogin = mkOption {
    type = types.attrsOf types.str;
  };

  config.systemd = {
    defaultUnit = mkDefault "graphical.target";
    services = {
      "autovt@tty1".enable = mkDefault false;
    } // concatMapAttrs (vt: user: {
      "vtlogin-${vt}" = let
        getty = "getty@tty${vt}.service";
        logind = "systemd-logind.service";
        plymouth = "plymouth-quit-wait.service";
        sessions = "systemd-user-sessions.service";
      in {
        wants = [ logind sessions ];
        after = [ getty logind plymouth sessions ];

        wantedBy = [ config.systemd.defaultUnit ];
        before = [ config.systemd.defaultUnit ];

        conflicts = [ getty ];

        unitConfig.ConditionPathExists = "/dev/tty${vt}";
        serviceConfig = {
          Restart = "always";

          ExecStartPre = "${vtwait}/bin/vtwait ${vt}";
          TimeoutStartSec = "infinity";

          ExecStart = "${pkgs.shadow}/bin/login -f ${user}";
          ImportCredential = "login.*";

          TTYPath = "/dev/tty${vt}";
          StandardInput = "tty";

          UtmpIdentifier = "tty${vt}";
          UtmpMode = "login";
        };

        restartIfChanged = false;
      };
    }) config.vtlogin;
  };
}
