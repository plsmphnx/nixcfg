{ config, ... }: {
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      open = true;

      modesetting.enable = true;
      powerManagement.enable = true;
    };
    nvidia-container-toolkit.enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
}
