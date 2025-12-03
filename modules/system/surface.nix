{ outputs, pkgs, ... }: {
  imports = with outputs.nixosModules; [ laptop ux hardware.cpu.intel ];

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.systemd-boot.enable = false;
  };

  environment = {
    systemPackages = [ pkgs.surface-control ];
    swap = 32;
  };

  services.logind.settings.Login.HandlePowerKey = "ignore";
}
