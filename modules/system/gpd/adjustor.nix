{ config, pkgs, ... }: {
  services.handheld-daemon.package = let
    adjustor = pkgs.callPackage ../../../packages/adjustor.nix {};
    python = pkgs.python3.withPackages (_: [ adjustor ] );
  in pkgs.handheld-daemon.overridePythonAttrs (old: {
    dependencies = old.dependencies ++ [ adjustor ];
    postFixup = ''
      wrapProgram "$out/bin/hhd" \
        --prefix PYTHONPATH : "$PYTHONPATH" \
        --prefix PATH : "${python}/bin"
    '';
  });

  boot.extraModulePackages = [ config.boot.kernelPackages.acpi_call ];
}
