inputs: {
  imports = [
    ../laptop.nix
    (import ../ux.nix inputs)
  ];

  boot.loader.efi.canTouchEfiVariables = false;

  hibernate.size = 4;

  hardware = {
    alsa.enablePersistence = true;
    deviceTree = {
      enable = true;
      name = "rockchip/rk3399-pinebook-pro.dtb";
    };
  };

  services.logind.settings.Login.HandlePowerKey = "ignore";
}
