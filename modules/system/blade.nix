inputs: { pkgs, lib, ... }: {
  imports = [
    ../core.nix
    ../laptop.nix
    ../login.nix
    (import ../ux.nix inputs)
    ../hardware/intel.nix
    ../hardware/nvidia.nix
    ../hardware/razer.nix
  ];

  networking.hostName = "clecompt-prime";

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest;

  swapDevices = [{
    device = "/swap";
    size = 32*1024;
  }];

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  environment.systemPackages = with pkgs; [
    wl-gammarelay-rs
  ];
}
