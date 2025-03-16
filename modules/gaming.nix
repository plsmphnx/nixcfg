{ pkgs, ... }: {
  boot = {
    # github:chaotic-cx/nyx/nyxpkgs-unstable
    kernelPackages =
      pkgs.linuxPackages_cachyos or pkgs.linuxPackages_xanmod_latest;
    kernelModules = [ "ntsync" ];
  };
  services.scx = {
    enable = true;
    scheduler = "scx_bpfland";
  };
  programs.gamemode.enable = true;
}
