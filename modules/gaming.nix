{ outputs, pkgs, ... }: {
  imports = with outputs.nixosModules; [ library.flatpak ux ];

  # cachyos.url = "github:xddxdd/nix-cachyos-kernel";
  # { nixpkgs.overlays = [ cachyos.overlay ]; }
  nix.settings = {
    substituters = [ "https://attic.xuyh0120.win/lantian" ];
    trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
  };

  boot = {
    kernelPackages = if pkgs ? "cachyosKernels"
      then pkgs.cachyosKernels.linuxPackages-cachyos-latest
      else pkgs.linuxPackages_xanmod_latest;
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
