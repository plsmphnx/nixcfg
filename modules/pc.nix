{ lib, pkgs, ... }: {
  boot.loader = {
    efi.canTouchEfiVariables = lib.mkDefault true;
    systemd-boot = {
      enable = lib.mkDefault true;
      configurationLimit = 4;
    };
  };

  environment.systemPackages = with pkgs; [
    lshw
    pciutils
    usbutils
  ];

  services.fwupd.enable = true;
}
