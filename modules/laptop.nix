{ config, pkgs, ... }: {
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  hardware.bluetooth.enable = true;
  powerManagement.enable = true;

  services = {
    upower.enable = true;
    logind = {
      powerKey = "ignore";
      lidSwitch = "suspend-then-hibernate";
    };
    thermald.enable = true;
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1800
  '';

  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
  ];

  users.users.clecompt.extraGroups = [ "networkmanager" ];
}
