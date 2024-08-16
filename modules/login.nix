{ lib, pkgs, ... }: let
  login = { user, default ? false }: {
    serviceConfig = {
      ExecStart = ["" "${pkgs.shadow}/bin/login -f ${user}"];
      Restart = "no";
    };
    overrideStrategy = "asDropin";
    wantedBy = lib.mkIf default [ "graphical.target" ];
  };
in {
  systemd = {
    defaultUnit = "graphical.target";
    services = {
      "getty@tty2" = login { user = "clecompt"; default = true; };
      "getty@tty3" = login { user = "clecompt"; };
    };
  };

  security = {
    pam.services = {
      login.enableGnomeKeyring = lib.mkForce false;
      lock.enableGnomeKeyring = true;
    };
    sudo.extraRules = [{
      users = [ "clecompt" ];
      commands = [{
        command = "/run/current-system/sw/bin/chvt";
        options = [ "NOPASSWD" ];
      }];
    }];
  };
}
