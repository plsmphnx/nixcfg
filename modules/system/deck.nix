# requires: github:jovian-experiments/jovian-nixos
inputs: { config, pkgs, lib, ... }: {
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
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelModules = [
      "ntsync"
      "steamdeck"
      "steamdeck-hwmon"
      "leds-steamdeck"
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

  environment.systemPackages = with pkgs; [
    jupiter-dock-updater-bin
    steamdeck-firmware
    tpm2-tss
  ];
}
