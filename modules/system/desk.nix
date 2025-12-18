{ outputs, ... }: {
  imports = with outputs.nixosModules; [
    gaming
    pc
    hardware.cpu.amd
    hardware.gpu.nvidia
  ];

  environment.swap = 96;
}
