inputs: { pkgs, ... }: {
  imports = [
    ../laptop.nix
    (import ../ux.nix inputs)
    ../hardware/cpu/intel.nix
  ];

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.systemd-boot.enable = false;
  };

  hibernate.size = 32;

  environment.systemPackages = [ pkgs.surface-control ];
}
