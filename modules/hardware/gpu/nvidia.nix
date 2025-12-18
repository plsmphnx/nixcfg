{ config, ... }: {
  hardware = {
    nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement.enable = true;
    };
    nvidia-container-toolkit.enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
}
