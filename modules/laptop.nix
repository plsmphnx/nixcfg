{ pkgs, ... }: {
  imports = [ ./pc.nix ];

  networking.networkmanager.wifi.backend = "iwd";
  hardware.bluetooth.enable = true;
  powerManagement.enable = true;

  services = {
    upower = {
      enable = true;
      criticalPowerAction = "PowerOff";
    };
    logind = {
      powerKey = "ignore";
      lidSwitch = "suspend-then-hibernate";
    };
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1800
  '';
}
