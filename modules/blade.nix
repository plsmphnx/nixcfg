{ config, pkgs, ... }: {
  networking.hostName = "clecompt-prime";

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 4;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      powerManagement.enable = true;
      prime = {
        sync.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };
    openrazer = {
      enable = true;
      users = [ "clecompt" ];
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # programs.sway = {
  #   extraOptions = [ "--unsupported-gpu" "-Dnoscanout" ];
  #   extraSessionCommands = ''
  #     export WLR_RENDERER=vulkan
  #     export WLR_DRM_DEVICES=/dev/dri/card0:/dev/dri/card1
  #     export WLR_NO_HARDWARE_CURSORS=1
  #   '';
  # };

  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtwayland
    openrazer-daemon
    polychromatic
  ];
}
