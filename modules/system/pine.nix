{ outputs, pkgs, ... }: {
  imports = with outputs.nixosModules; [ laptop ux ];

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

  nixpkgs.overlays = [ (final: prev: {
    linux-firmware = prev.linux-firmware.overrideAttrs (old: rec {
      version = "20260810";
      src = pkgs.fetchFromGitLab {
        owner = "kernel-firmware";
        repo = "linux-firmware";
        tag = version;
        hash = "sha256-P/fPpqaatp8Z2GV+I/OChiWGn6AhV+8w1RMFuX/LqHc=";
      };
    });
  }) ];
}
