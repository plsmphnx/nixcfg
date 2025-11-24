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
    hibernate.size = 32;
    systemPackages = [ pkgs.surface-control ];
  };

  services.logind.settings.Login.HandlePowerKey = "ignore";
}
