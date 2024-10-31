inputs: { ... }: {
  imports = [
    ../core.nix
    ../laptop.nix
    ../login.nix
    (import ../ux.nix inputs)
  ];

  networking.hostName = "clecompt-pine";

  boot = {
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
      configurationLimit = 4;
    };
    kernelModules = [ "rkvdec" ];
  };

  hardware.alsa.enablePersistence = true;
}
