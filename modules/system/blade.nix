inputs: { pkgs, ... }: {
  imports = [
    (import ../gaming.nix inputs)
    ../laptop.nix
    ../hardware/cpu/intel.nix
    ../hardware/gpu/nvidia.nix
  ];

  hibernate.size = 32;

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  environment.systemPackages = [ pkgs.wl-gammarelay-rs ];
}
