{ config, lib, ... }: {
  imports = [ ./pc.nix ];

  networking.networkmanager.wifi.backend = "iwd";
  hardware.bluetooth.enable = true;

  environment.hibernate.options = {
    DelaySec = "1800";
    OnACPower = "no";
  };

  services = {
    upower = {
      enable = true;
      criticalPowerAction = "PowerOff";
    };
    logind.settings.Login = let
      suspend = if (config.environment.hibernate.size != null)
        then "suspend-then-hibernate" else "suspend";
    in {
      HandleLidSwitch = lib.mkDefault suspend;
      HandlePowerKey = lib.mkDefault suspend;
    };
  };
}
