# github:jovian-experiments/jovian-nixos
inputs: { config, lib, pkgs, ... }: let 
  steamdeck-dkms = config.boot.kernelPackages.callPackage
    ../../packages/steamdeck-dkms.nix {};
in {
  imports = [
    (import ../gaming.nix inputs)
    ../laptop.nix
  ];

  jovian = {
    devices.steamdeck = {
      enable = true;
      enableKernelPatches = false;
    };
    steam = {
      enable = true;
      environment.XKB_DEFAULT_OPTIONS = "srvrkeys:none";
    };
    steamos = {
      useSteamOSConfig = false;
      enableDefaultCmdlineConfig = true;
      enableSysctlConfig = true;
    };
  };

  boot = {
    extraModulePackages = [ steamdeck-dkms ];
    kernelModules = [
      "steamdeck"
      "steamdeck_leds"
      "steamdeck_hwmon"
      "steamdeck_extcon"
    ];
    loader.systemd-boot.consoleMode = "5";
  };

  hibernate = {
    size = 16;
    mode = "shutdown";
  };

  environment.systemPackages = with pkgs; [
    jupiter-dock-updater-bin
    steamdeck-firmware
    tpm2-tss
  ];

  services.flatpak.removeCapSysNice = true;
}
