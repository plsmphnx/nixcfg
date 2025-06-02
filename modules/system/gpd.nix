inputs: { pkgs, user, ... }: {
  imports = [
    (import ../gaming.nix inputs)
    ../laptop.nix
    ../hardware/cpu/amd.nix
    ../hardware/gpu/amd.nix
  ];

  hibernate = {
    size = 48;
    mode = "shutdown";
  };

  environment.systemPackages = with pkgs; [ tpm2-tss ];

  services.handheld-daemon = {
    enable = true;
    inherit user;
  };
}
