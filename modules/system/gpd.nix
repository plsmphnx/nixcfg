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
}
