# requires: github:jovian-experiments/jovian-nixos
inputs: { config, pkgs, lib, ... }: let 
  steamdeck-dkms = config.boot.kernelPackages.callPackage
    ../../packages/steamdeck-dkms.nix {};
in {
  imports = [
    ../core.nix
    ../laptop.nix
    ../login.nix
    (import ../ux.nix inputs)
  ];

  networking.hostName = "clecompt-deck";

  jovian = {
    devices.steamdeck = {
      enable = true;
      enableKernelPatches = false;
    };
    steamos = {
      useSteamOSConfig = false;
      enableDefaultCmdlineConfig = true;
      enableSysctlConfig = true;
    };
    steam = {
      enable = true;
      environment.XKB_DEFAULT_OPTIONS = "srvrkeys:none";
    };
  };

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest;
    extraModulePackages = [ steamdeck-dkms ];
    kernelModules = [
      "ntsync"
      "steamdeck"
      "steamdeck_leds"
      "steamdeck_hwmon"
      "steamdeck_extcon"
    ];

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 4;
        consoleMode = "auto";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  swapDevices = [{
    device = "/swap";
    size = 16*1024;
  }];

  environment = {
    etc.timezone.text = config.time.timeZone + "\n";
    systemPackages = with pkgs; [
      jupiter-dock-updater-bin
      steamdeck-firmware
      tpm2-tss
    ];
  };

  security.wrappers.flatpak = {
    owner = "root";
    group = "root";
    source = "${pkgs.flatpak}/bin/flatpak";
    capabilities = "cap_sys_nice-pie";
  };
}
