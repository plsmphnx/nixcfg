{ lib, pkgs, user, ... }: {
  systemd.services."getty@".serviceConfig.ExecStart = lib.mkForce [
    ""
    "${pkgs.shadow}/bin/login -f ${user}"
  ];

  security = {
    pam.services.login.enableGnomeKeyring = lib.mkForce false;
    sudo.extraRules = [{
      users = [ user ];
      commands = [{
        command = "/run/current-system/sw/bin/chvt";
        options = [ "NOPASSWD" ];
      }];
    }];
  };
}
