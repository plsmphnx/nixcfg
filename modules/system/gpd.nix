inputs: { lib, pkgs, user, ... }: {
  imports = [
    (import ../gaming.nix inputs)
    ../laptop.nix
    ../hardware/cpu/amd.nix
    ../hardware/gpu/amd.nix
    inputs.gpdfan.nixosModules.default
    ../library/handheld-daemon.nix
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
      fanSleep = "manual_edge";
      controllerTarget = true;
    };
    memreserver.enable = true;
  };

  hardware.gpd-fan.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
}
