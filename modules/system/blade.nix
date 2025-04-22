inputs: { pkgs, lib, ... }: {
  imports = [
    ../gaming.nix
    ../laptop.nix
    ../login.nix
    (import ../ux.nix inputs)
    ../hardware/intel.nix
    ../hardware/nvidia.nix
  ];

  networking.hostName = "clecompt-prime";

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
