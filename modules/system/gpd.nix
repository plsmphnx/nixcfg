inputs: { lib, pkgs, user, ... }: {
  imports = [
    (import ../gaming.nix inputs)
    ../laptop.nix
    ../hardware/cpu/amd.nix
    ../hardware/gpu/amd.nix
    inputs.gpdfan.nixosModules.default
    ../library/adjustor.nix
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
      adjustor.enable = true;
    };
    memreserver.enable = true;
    udev.extraRules = ''
      KERNELS=="input[0-9]*", SUBSYSTEMS=="input", ATTRS{name}=="Handheld Daemon Controller", SYMLINK+="hhd", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="hhd.target"
    '';
  };

  hardware.gpd-fan.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  systemd = {
    user.targets.hhd = {
      bindsTo = [ "dev-hhd.device" ];
      after   = [ "dev-hhd.device" "default.target" ];
    };
    services = let
      hhdctl = lib.getExe' pkgs.handheld-daemon "hhdctl";
      fans = val: dir: tgt: {
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${hhdctl} set tdp.qam.fan.mode=${val}";
        };
        wantedBy = [ tgt ];
        ${dir} = [ tgt ];
      };
    in {
      fan-sleep = fans "disabled" "before" "sleep.target";
      fan-awake = fans "manual_edge" "after" "post-resume.target";
    };
  };
}
