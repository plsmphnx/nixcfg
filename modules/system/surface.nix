inputs: { config, lib, pkgs, ... }: {
  imports = [
    ../laptop.nix
    (import ../ux.nix inputs)
    ../hardware/intel.nix
  ];

  networking.hostName = "clecompt-surface";

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.systemd-boot.enable = false;
  };

  swapDevices = [{
    device = "/swap";
    size = 32*1024;
  }];

  environment.systemPackages = with pkgs; [
    surface-control
  ];
}
