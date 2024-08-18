{ config, lib, pkgs, ... }: let
  vtwait = pkgs.writeCBin "vtwait" ''
    #include <stdlib.h>
    #include <linux/vt.h>
    #include <sys/ioctl.h>
    int main(int argc, char *argv[]) {
      return ioctl(0, VT_WAITACTIVE, atoi(argv[1]));
    }
  '';

  tty = vt: "tty${vt}";
  dev = vt: "/dev/${tty vt}";
  getty = vt: "getty@${tty vt}.service";
  logind = "systemd-logind.service";
  plymouth = "plymouth-quit-wait.service";
  user-sessions = "user-sessions.service";
in with lib; {
  options.vtlogin = mkOption {
    type = types.attrsOf types.str;
  };

  config.systemd = {
    defaultUnit = mkDefault "graphical.target";
    services = {
      "autovt@tty1".enable = mkDefault false;
    } // concatMapAttrs (vt: user: {
      "vtlogin-${vt}" = {
        wants = [ logind user-sessions ];
        after = [ (getty vt) logind plymouth user-sessions ];

        wantedBy = [ config.systemd.defaultUnit ];
        before = [ config.systemd.defaultUnit ];

        conflicts = [ (getty vt) ];

        unitConfig.ConditionPathExists = dev vt;
        serviceConfig = {
          Type = "idle";
          Restart = "always";
          RestartSec = 0;

          ExecStartPre = "${vtwait}/bin/vtwait ${vt}";
          TimeoutStartSec = "infinity";

          ExecStart = "${pkgs.shadow}/bin/login -f ${user}";
          ImportCredential = "login.*";

          TTYPath = dev vt;
          TTYReset = true;
          TTYVHangup = true;
          TTYVTDisallocate = true;

          IgnoreSIGPIPE = false;
          SendSIGHUP = true;

          UtmpIdentifier = tty vt;
          UtmpMode = "login";

          StandardInput = "tty";
        };

        restartIfChanged = false;
      };
    }) config.vtlogin;
  };
}
