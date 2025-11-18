inputs: { lib, pkgs, user, ... }: {
  imports = [
    (import ../gaming.nix inputs)
    ../laptop.nix
    ../hardware/cpu/amd.nix
    ../hardware/gpu/amd.nix
    inputs.gpdfan.nixosModules.default
    ../library/handheld-daemon.nix
  ];

  hibernate = {
    size = 64;
    options.Mode = "shutdown";
  };

  environment.systemPackages = [ pkgs.tpm2-tss ];

  services = {
    handheld-daemon = {
      enable = true;
      ui.enable = true;
      adjustor.enable = true;
      inherit user;
      config = {
        hhd.settings.tdp_enable = true;
        tdp = {
          qam = {
            tdp = 15;
            boost = false;
          };
          amd_energy.mode = {
            mode = "manual";
            manual = {
              cpu_pref = "power";
              cpu_boost = "disabled";
            };
          };
        };
      };
      fan = {
        mode = "edge";
        sleep = true;
        fn = t: (t * t) / 0.81;
      };
    };
    memreserver.enable = true;
  };

  hardware = {
    amdgpu.performanceLevel = "low";
    gpd-fan.enable = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  systemd.user.devices.hhd.name = "Handheld Daemon Controller";
}
