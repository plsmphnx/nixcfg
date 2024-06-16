{ config, pkgs, ... }: {
  imports = [
    ./core.nix
    ./laptop.nix
    ./ux.nix
    ./hardware/intel.nix
    ./hardware/nvidia.nix
    ./hardware/razer.nix
  ];

  networking.hostName = "clecompt-prime";

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 4;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
  };

  hardware.nvidia.prime = {
    sync.enable = true;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };
}
