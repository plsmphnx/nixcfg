# chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
# chaotic.nixosModules.default
{ pkgs, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    kernelModules = [ "ntsync" ];
  };
  services.scx = {
    enable = true;
    scheduler = "scx_bpfland";
  };
  programs.gamemode.enable = true;
}
