{ lib, pkgs, ... }: {
  systemd.services."getty@".serviceConfig.ExecStart = lib.mkForce [
    ""
    "${pkgs.shadow}/bin/login -f clecompt"
  ];

  security = {
    pam.services.login.enableGnomeKeyring = lib.mkForce false;
    sudo.extraRules = [{
      users = [ "clecompt" ];
      commands = [{
        command = "/run/current-system/sw/bin/chvt";
        options = [ "NOPASSWD" ];
      }];
    }];
  };
}
