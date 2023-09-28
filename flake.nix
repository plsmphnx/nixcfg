{
  outputs = { self, nixpkgs }: let
    attrs = k: f: builtins.listToAttrs
      (map (n: { name = n; value = f n; }) k);
  in {
    nixosModules = {
      blade = import ./modules/blade.nix;
      core = import ./modules/core.nix;
      laptop = import ./modules/laptop.nix;
      pbp = import ./modules/pbp.nix;
      ux = import ./modules/ux.nix;
    };
    packages = attrs [ "x86_64-linux" "aarch64-linux" ]
      (system: let
        pkgs = import nixpkgs { inherit system; };
      in {
        megazeux = import ./games/megazeux.nix pkgs;
        redact-pdf = import ./tools/redact-pdf.nix pkgs;
        retro = with pkgs; retroarch.override {
          cores = with libretro; [
            tic80
          ];
        };
      });
  };
}
