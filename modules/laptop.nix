{ config, ... }: {
  imports = [
    ./library/hibernate.nix
    ./pc.nix
  ];

  networking.networkmanager.wifi.backend = "iwd";
  hardware.bluetooth.enable = true;

  services = {
    upower = {
      enable = true;
      criticalPowerAction = "PowerOff";
    };
    logind.settings.Login = {
      HandlePowerKey = "ignore";
      HandleLidSwitch = if (config.hibernate.size != null)
        then "suspend-then-hibernate" else "suspend";
    };
  };
}
