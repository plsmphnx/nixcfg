{
  services.udev.extraRules = ''
    ATTRS{idVendor}=="27b8", ATTRS{idProduct}=="01ed", MODE:="666", GROUP="wheel"
  '';

  systemd.user.devices.blink1 = {
    idVendor = "27b8";
    idProduct = "01ed";
  };
}
