{ config, pkgs, ... }:{
  imports = [
    <nixos-hardware/pine64/pinebook-pro>
  ];

  networking.hostName = "clecompt-pine";
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  boot.consoleLogLevel = 2;
}
