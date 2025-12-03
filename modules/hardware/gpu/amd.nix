{ outputs, ... }: {
  imports = with outputs.nixosModules.library; [ amdgpu memreserver ];
  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
  };
}
