{ outputs, pkgs, ... }: {
  imports = with outputs.nixosModules; [ library.flatpak ux ];

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
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
