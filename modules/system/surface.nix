inputs: { config, lib, pkgs, ... }: {
  imports = [
    ../core.nix
    ../laptop.nix
    ../login.nix
    (import ../ux.nix inputs)
    ../hardware/intel.nix
  ];

  networking.hostName = "clecompt-dev";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
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
