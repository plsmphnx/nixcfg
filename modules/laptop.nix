{ config, lib, outputs, ... }: {
  imports = with outputs.nixosModules; [ pc ];

  hardware.bluetooth.enable = true;

  environment.hibernate = {
    enable = lib.mkDefault (config.environment.swap > 0);
    options = {
      DelaySec = "1800";
      OnACPower = "no";
    };
  };

  services = {
    upower = {
      enable = true;
      criticalPowerAction = "PowerOff";
    };
    logind.settings.Login = let
      suspend = if config.environment.hibernate.enable
        then "suspend-then-hibernate" else "suspend";
    in {
      HandleLidSwitch = lib.mkDefault suspend;
      HandlePowerKey = lib.mkDefault suspend;
    };
  };
}
