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
      config.tdp = {
        qam = {
          tdp = 15;
          boost = false;
          fan = {
            mode = "manual_edge";
            manual_edge = lib.listToAttrs (map (temp: {
              name = "st${toString temp}";
              value = (100 * temp * temp) / (90 * 90);
            }) [ 40 45 50 55 60 65 70 80 90 ]);
          };
        };
        amd_energy.mode = {
          mode = "manual";
          manual = {
            cpu_pref = "power";
            cpu_boost = "disabled";
          };
        };
      };
      adjustor.enable = true;
      fanSleep = "manual_edge";
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
