{ config, ... }: {
  imports = [
    ./library/hibernate.nix
    ./pc.nix
  ];

  networking.networkmanager.wifi.backend = "iwd";
  hardware.bluetooth.enable = true;

  hibernate.options = {
    DelaySec = "1800";
    OnACPower = "no";
  };

  services = {
    upower = {
      enable = true;
      criticalPowerAction = "PowerOff";
    };
    logind.settings.Login.HandleLidSwitch = if (config.hibernate.size != null)
      then "suspend-then-hibernate" else "suspend";
  };
}
