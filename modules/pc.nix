{ config, lib, outputs, pkgs, user, ... }: let
  mkUserDefault = lib.mkOverride 1250;
in {
  imports = with outputs.nixosModules; [ core ];

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

  environment.systemPackages = with pkgs; [ lshw pciutils usbutils ];

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    logind.settings.Login.HandlePowerKey = mkUserDefault "suspend";
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
    networkmanager.wifi.backend = "iwd";
    nftables.enable = true;
    firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];
  };

  hardware.enableAllFirmware = true;

  zramSwap.enable = true;
}
