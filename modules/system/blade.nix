{ outputs, pkgs, ... }: {
  imports = with outputs.nixosModules; [
    gaming
    laptop
    hardware.cpu.intel
    hardware.gpu.nvidia
  ];

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  systemd.user.devices = {
    nvidia = {
      vendor = "0x10de";
      device = "0x249c";
    };
    intel = {
      vendor = "0x8086";
      device = "0x9a60";
    };
  };

  environment = {
    hibernate.enable = false;
    systemPackages = [ pkgs.wl-gammarelay-rs ];
    swap = 32;
  };
}
