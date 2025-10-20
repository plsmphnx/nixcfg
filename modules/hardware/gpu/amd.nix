{
  imports = [
    ../../library/amdgpu.nix
    ../../library/memreserver.nix
  ];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };
  };
}
