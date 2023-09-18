{
  outputs = _: {
    nixosModules = {
      core = import ./core.nix;
    };
  };
}
