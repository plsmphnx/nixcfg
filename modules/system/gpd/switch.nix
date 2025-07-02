{
  systemd.user.targets.hhd = {
    bindsTo = [ "dev-hhd.device" ];
    after   = [ "dev-hhd.device" "default.target" ];
  };
  services.udev.extraRules = ''
    KERNELS=="input[0-9]*", SUBSYSTEMS=="input", ATTRS{name}=="Handheld Daemon Controller", SYMLINK+="hhd", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="hhd.target"
  '';
}
