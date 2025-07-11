{ config, lib, pkgs, user, ... }: let
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
    initrd.systemd.enable = true;
    enableContainers = false;
  };

  environment.systemPackages = with pkgs; [
    lshw
    pciutils
    usbutils
  ];

  services = {
    fwupd.enable = true;
    openssh = {
      enable = true;
      openFirewall = false;
      startWhenNeeded = true;
      settings = {
        AllowUsers = [ user ];
        PermitRootLogin = "no";
      };
    };
    tailscale = {
      enable = true;
      extraSetFlags = [ "--operator=${user}" ];
      extraDaemonFlags = [ "--no-logs-no-support" ];
      interfaceName = "vpn0";
    };
  };

  networking = {
    nftables.enable = true;
    firewall.trustedInterfaces = [
      config.services.tailscale.interfaceName
    ];
  };

  hardware.enableAllFirmware = true;
}
