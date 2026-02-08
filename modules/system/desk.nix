{ outputs, ... }: {
  imports = with outputs.nixosModules; [
    gaming
    pc
    hardware.cpu.amd
    hardware.gpu.nvidia
  ];

  hardware.bluetooth.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="0616", ATTR{authorized}="0"
  '';
}
