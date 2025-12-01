{ outputs, ... }: {
  imports = [
    outputs.nixosModules.library.amdgpu
    outputs.nixosModules.library.memreserver
  ];
  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
  };
}
