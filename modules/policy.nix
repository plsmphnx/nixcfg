{ config, lib, pkgs, ... }: {
  boot = {
    bootspec.enable = true;
    loader.efi.canTouchEfiVariables = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
      configurationLimit = 4;
    };
  };

  services = {
    gnome.glib-networking.enable = true;
    intune.enable = true;
  };

  environment.etc.os-release.source = lib.mkForce (pkgs.fetchurl {
    url = "https://github.com/which-distro/os-release/raw/main/ubuntu/22.04";
    hash = "sha256-srkXEKSuK9l+M8Lq6Hc+jhRkQ3eipkcM0ZSe6Xz1OOo=";
  });

  systemd = {
    user.timers.intune-agent.wantedBy = [ "graphical-session.target" ];
    sockets.intune-daemon.wantedBy = [ "sockets.target" ];
  };

  security.pam.services.common-password.rules.password.pwquality = {
    control = "required"; 
    modulePath = "${pkgs.libpwquality.lib}/lib/security/pam_pwquality.so"; 
    order = config.security.pam.services.common-password.rules.password.unix.order - 10;
    settings = {
      minlen = 12;
      dcredit = -1;
      ucredit = -1;
      lcredit = -1;
      ocredit = -1;
      enforce_for_root = true;
    }; 
  };
}
