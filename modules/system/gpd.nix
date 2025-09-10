inputs: { pkgs, user, ... }: {
  imports = [
    (import ../gaming.nix inputs)
    ../laptop.nix
    ../hardware/cpu/amd.nix
    ../hardware/gpu/amd.nix
    inputs.gpdfan.nixosModules.default
    ./gpd/adjustor.nix
  ];

  hibernate = {
    size = 64;
    mode = "shutdown";
  };

  environment.systemPackages = [ pkgs.tpm2-tss ];

  services = {
    handheld-daemon = {
      enable = true;
      inherit user;
    };
    memreserver.enable = true;
  };

  hardware.gpd-fan.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  systemd.user.targets.hhd = {
    bindsTo = [ "dev-hhd.device" ];
    after   = [ "dev-hhd.device" "default.target" ];
  };
  services.udev.extraRules = ''
    KERNELS=="input[0-9]*", SUBSYSTEMS=="input", ATTRS{name}=="Handheld Daemon Controller", SYMLINK+="hhd", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="hhd.target"
  '';
}
