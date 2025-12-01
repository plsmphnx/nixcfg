{ outputs, ... }: {
  imports = [
    outputs.nixosModules.laptop
    outputs.nixosModules.ux
  ];

  boot.loader.efi.canTouchEfiVariables = false;

  environment.swap = 4;

  hardware = {
    alsa.enablePersistence = true;
    deviceTree = {
      enable = true;
      name = "rockchip/rk3399-pinebook-pro.dtb";
    };
  };

  services.logind.settings.Login.HandlePowerKey = "ignore";
}
