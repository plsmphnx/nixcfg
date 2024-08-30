{ lib, pkgs, ... }: {
  imports = [ ./vtlogin.nix ];

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
