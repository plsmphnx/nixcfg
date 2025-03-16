{ lib, pkgs, ... }: {
  imports = [ ./core.nix ];

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = lib.mkDefault true;
      systemd-boot = {
        enable = lib.mkDefault true;
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
