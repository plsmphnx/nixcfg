{ config, lib, outputs, packages, pkgs, ... }: {
  imports = with outputs.nixosModules; [
    gaming
    laptop
    hardware.cpu.amd
    hardware.gpu.amd
    library.fan2go
  ];

  environment = {
    hibernate.workaround = [ "/swap" ];
    systemPackages = [ pkgs.tpm2-tss ];
    swap = 64;
  };

  services = {
    fan2go = {
      enable = true;
      package = packages.${pkgs.stdenv.hostPlatform.system}.fan2go;
      config = {
        fans = [{
          id = "gpdfan";
          hwmon = {
            platform = "gpdfan";
            rpmChannel = 1;
          };
          curve = "manual";
        }];
        sensors = [{
          id = "edge";
          hwmon = {
            platform = "amdgpu";
            index = 1;
          };
        }];
        curves = [{
          id = "manual";
          linear = {
            sensor = "edge";
            steps = with lib; map (n: {
              ${toString (5*n + 40)} = "${toString (ceil (0.9*n*n) + 10)}%";
            }) (range 0 10);
          };
        }];
      };
    };
    logind.settings.Login.HandlePowerKey = "hibernate";
    tuned.enable = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  systemd.user.devices.gamepad.phys = "usb-0000:c6:00.0-3.1/input0";

  boot.kernelModules = [ "gpd_fan" ];

  environment.etc."systemd/system-sleep/fan.sh".source = let
    systemctl = lib.getExe' config.systemd.package "systemctl";
  in pkgs.writeScript "fan" ''
    #!/bin/sh
    case $1 in
      pre) ${systemctl} stop fan2go ;;
      post) ${systemctl} start fan2go ;;
    esac
  '';
}
