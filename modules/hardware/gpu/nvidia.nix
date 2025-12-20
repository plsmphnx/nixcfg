{ config, ... }: {
  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      open = true;
      modesetting.enable = true;
      powerManagement.enable = true;
    };
    nvidia-container-toolkit.enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
}
