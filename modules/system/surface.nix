inputs: { pkgs, ... }: {
  imports = [
    ../laptop.nix
    (import ../ux.nix inputs)
    ../hardware/intel.nix
  ];

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.systemd-boot.enable = false;
  };

  swapDevices = [{
    device = "/swap";
    size = 32*1024;
  }];

  environment.systemPackages = [ pkgs.surface-control ];
}
