{ outputs, pkgs, ... }: {
  imports = [
    outputs.nixosModules.laptop
    outputs.nixosModules.ux
    outputs.nixosModules.hardware.cpu.intel
  ];

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
