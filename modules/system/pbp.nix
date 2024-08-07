inputs: { ... }: {
  imports = [
    ../core.nix
    ../laptop.nix
    (import ../ux.nix inputs)
    ../login.nix
  ]

  networking.hostName = "clecompt-pine";

  boot = {
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
      configurationLimit = 4;
    };

    consoleLogLevel = 2;

    kernelModules = [ "rkvdec" ];
  };

  sound.enable = true;
}
