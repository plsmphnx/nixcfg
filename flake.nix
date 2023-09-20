{
  outputs = { self, nixpkgs }: {
    nixosModules = {
      core = import ./modules/core.nix;
      laptop = import ./modules/laptop.nix;
      pbp = import ./modules/pbp.nix;
      ux = import ./modules/ux.nix;
    };
    packages = {
      aarch64-linux = let
        pkgs = import nixpkgs { system = "aarch64-linux"; };
      in {
        megazeux = import ./games/megazeux.nix pkgs;
      };
    };
  };
}
