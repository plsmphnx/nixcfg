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
    mode = "shutdown";
  };

  environment.systemPackages = [ pkgs.tpm2-tss ];

  services = {
    handheld-daemon = {
      enable = true;
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
      adjustor.enable = true;
      fan = {
        mode = "manual_edge";
        sleep = true;
        fn = t: t * t;
      };
      controllerTarget = true;
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
}
