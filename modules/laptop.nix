{ pkgs, ... }: {
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
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1800
  '';

  environment.systemPackages = with pkgs; [
    lshw
    pciutils
    usbutils
  ];

  users.users.clecompt.extraGroups = [ "networkmanager" ];
}
