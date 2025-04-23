inputs: { pkgs, ... }: {
  imports = [
    (import ../gaming.nix inputs)
    ../laptop.nix
    ../hardware/intel.nix
    ../hardware/nvidia.nix
  ];

  swapDevices = [{
    device = "/swap";
    size = 32*1024;
  }];

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  environment.systemPackages = [ pkgs.wl-gammarelay-rs ];
}
