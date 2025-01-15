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

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 4;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest;
    kernelModules = [ "ntsync" ];
    boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  };

  hardware.nvidia = {
    prime = {
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
    open = false;
  };

  environment.systemPackages = with pkgs; [
    wl-gammarelay-rs
  ];
}
