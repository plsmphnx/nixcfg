{ outputs, ... }: {
  imports = with outputs.nixosModules; [
    gaming
    pc
    hardware.cpu.amd
    hardware.gpu.nvidia
  ];

  hardware.bluetooth.enable = true;
}
