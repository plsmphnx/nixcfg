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

  environment = {
    systemPackages = [ pkgs.surface-control ];
    swap = 32;
  };

  services.logind.settings.Login.HandlePowerKey = "ignore";
}
