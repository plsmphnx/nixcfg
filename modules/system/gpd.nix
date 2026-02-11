{ outputs, pkgs, user, ... }: {
  imports = with outputs.nixosModules; [
    gaming
    laptop
    hardware.cpu.amd
    hardware.gpu.amd
    library.handheld-daemon
  ];

  environment = {
    hibernate.workaround = [ "/swap" ];
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
        gamemode.power.hibernate_auto = false;
      };
      fan = {
        mode = "edge";
        sleep = true;
        fn = t: (3.2 * t * t) - (2.56 * t) + 0.712;
      };
    };
    logind.settings.Login.HandlePowerKey = "hibernate";
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  systemd.user.devices.gamepad.phys = "usb-0000:c6:00.0-3.1/input0";

  boot.kernelModules = [ "gpd_fan" ];
}
