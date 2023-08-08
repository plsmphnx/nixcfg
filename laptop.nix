{ config, pkgs, ... }:{
  networking.wireless.iwd.enable = true;
  hardware.bluetooth.enable = true;
  powerManagement.enable = true;
  services.upower.enable = true;

  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';

  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
  ];
}
