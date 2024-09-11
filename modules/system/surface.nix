inputs: { config, lib, pkgs, ... }: {
  imports = [
    ../core.nix
    ../laptop.nix
    ../login.nix
    ../msft.nix
    (import ../ux.nix inputs)
    ../hardware/intel.nix
  ];

  networking.hostName = "clecompt-dev";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    bootspec.enable = true;
    loader.efi.canTouchEfiVariables = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
      configurationLimit = 4;
    };
  };

  swapDevices = [{
    device = "/swap";
    size = 32*1024;
  }];

  environment.systemPackages = with pkgs; [
    surface-control
  ];
}
