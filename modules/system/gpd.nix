inputs: { config, pkgs, user, ... }: {
  imports = [
    (import ../gaming.nix inputs)
    ../laptop.nix
    ../hardware/cpu/amd.nix
    ../hardware/gpu/amd.nix
    inputs.gpdfan.nixosModules.default
  ];

  hibernate = {
    size = 48;
    mode = "shutdown";
  };

  environment.systemPackages = [ pkgs.tpm2-tss ];

  services.handheld-daemon = {
    enable = true;
    inherit user;

    package = let
      adjustor = pkgs.callPackage ../../packages/adjustor.nix {};
      python = pkgs.python3.withPackages (_: [ adjustor ] );
    in pkgs.handheld-daemon.overridePythonAttrs (old: {
      dependencies = old.dependencies ++ [ adjustor ];
      postFixup = ''
        wrapProgram "$out/bin/hhd" \
          --prefix PYTHONPATH : "$PYTHONPATH" \
          --prefix PATH : "${python}/bin"
      '';
    });
  };

  boot.extraModulePackages = [ config.boot.kernelPackages.acpi_call ];

  hardware.gpd-fan.enable = true;

  systemd.services = let
    fans = val: dir: tgt: cfg: let
      path = "/sys/devices/platform/gpd_fan/hwmon/hwmon*/pwm1_enable";
      tgts = map (t: t + ".target") tgt;
    in {
      serviceConfig = {
        Kind = "oneshot";
        ExecStart = "/bin/sh -c 'echo ${toString val} | tee ${path}'";
      };
      wantedBy = tgts;
      ${dir} = tgts;
    } // cfg;
  in {
    fan-sleep = fans 2 "before" [ "sleep" "shutdown" ] {};
    fan-awake = fans 1 "after" [ "suspend" "hibernate" ] {
      requisite = [ "handheld-daemon.service" ];
    };
  };
}
