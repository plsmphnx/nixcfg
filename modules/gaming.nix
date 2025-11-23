inputs: { pkgs, ... }: {
  imports = [
    ./library/flatpak.nix
    (import ./ux.nix inputs)
  ];

  boot = {
    # github:chaotic-cx/nyx/nyxpkgs-unstable
    kernelPackages =
      pkgs.linuxPackages_cachyos-gcc or pkgs.linuxPackages_xanmod_latest;
    kernelModules = [ "ntsync" ];
  };

  services = {
    ratbagd.enable = true;
    scx = {
      enable = true;
      scheduler = "scx_bpfland";
    };
  };

  hardware = {
    graphics.enable32Bit = true;
    steam-hardware.enable = true;
    xpadneo.enable = true;
  };
}
