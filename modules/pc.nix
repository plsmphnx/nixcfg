{ lib, pkgs, ... }: let
  mkUserDefault = lib.mkOverride 1250;
in{
  imports = [ ./core.nix ];

  boot = {
    kernelPackages = mkUserDefault pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = mkUserDefault true;
      systemd-boot = {
        enable = mkUserDefault true;
        configurationLimit = 4;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    lshw
    pciutils
    usbutils
  ];

  services.fwupd.enable = true;
}
