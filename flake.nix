{
  inputs = let
    nixpkg = url: { inherit url; inputs.nixpkgs.follows = "nixpkgs"; };
  in {
    nixpkgs.url  = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "git+https://github.com/hyprwm/hyprland?submodules=1";

    ags       = nixpkg "github:aylur/ags";
    exec-util = nixpkg "github:plsmphnx/exec-util";
    hyprmks   = nixpkg "github:plsmphnx/hyprmks";
  };
  outputs = { self, nixpkgs, ... } @ inputs: let
    systems = fn: nixpkgs.lib.mapAttrs (_: fn) nixpkgs.legacyPackages;
  in {
    nixosModules = {
      core = import ./modules/core.nix;
      edge = import ./modules/edge.nix inputs;
      laptop = import ./modules/laptop.nix;
      login = import ./modules/login.nix;
      msft = import ./modules/msft.nix;
      ux = import ./modules/ux.nix inputs;

      blade = import ./modules/system/blade.nix inputs;
      pbp = import ./modules/system/pbp.nix inputs;
      surface = import ./modules/system/surface.nix inputs;
    };
    packages = systems (pkgs: {
      megazeux = pkgs.callPackage ./packages/megazeux.nix {};
    });
  };
}
