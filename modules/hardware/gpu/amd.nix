{
  imports = [
    ../../library/amdgpu.nix
    ../../library/memreserver.nix
  ];
  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
  };
}
