inputs: { ... }: {
  imports = [
    ../core.nix
    ../laptop.nix
    ../login.nix
    (import ../ux.nix inputs)
  ];

  networking.hostName = "clecompt-pine";

  boot.loader.efi.canTouchEfiVariables = false;

  hardware = {
    alsa.enablePersistence = true;
    deviceTree = {
      enable = true;
      name = "rockchip/rk3399-pinebook-pro.dtb";
    };
  };
}
