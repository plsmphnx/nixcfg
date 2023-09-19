{
  outputs = _: {
    nixosModules = {
      core = import ./core.nix;
      laptop = import ./laptop.nix;
      pbp = import ./pbp.nix;
      ux = import ./ux.nix;
    };
  };
}
