{ ... }: {
  services.thermald.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
}
