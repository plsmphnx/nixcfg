{ outputs, pkgs, user, ... }: {
  imports = with outputs.nixosModules; [
    gaming
    laptop
    hardware.cpu.amd
    hardware.gpu.amd
    library.handheld-daemon
  ];

  environment = {
    hibernate.options.Mode = "shutdown";
    systemPackages = [ pkgs.tpm2-tss ];
    swap = 64;
  };

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
    logind.settings.Login.HandlePowerKey = "hibernate";
  };

  hardware.amdgpu.performanceLevel = "low";

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  systemd.user.devices.gamepad.phys = "usb-0000:c6:00.0-3.1/input0";

  boot.kernelModules = [ "gpd_fan" ];
}
