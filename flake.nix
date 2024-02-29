{
  inputs = {
    nixpkgs.url  = "github:nixos/nixpkgs/nixos-unstable";
    ags.url      = "github:aylur/ags";
    hyprland.url = "github:hyprwm/hyprland";
    hypridle.url = "github:hyprwm/hypridle";
    hyprlock.url = "github:hyprwm/hyprlock";
  };
  outputs = { self, nixpkgs, ... } @ inputs: let
    systems = fn: nixpkgs.lib.mapAttrs (_: fn) nixpkgs.legacyPackages;
  in {
    nixosModules = {
      blade = import ./modules/blade.nix;
      core = import ./modules/core.nix;
      laptop = import ./modules/laptop.nix;
      pbp = import ./modules/pbp.nix;
      policy = import ./modules/policy.nix;
      ux = import ./modules/ux.nix inputs;
    };
    packages = systems (pkgs: {
      megazeux = pkgs.callPackage ./packages/megazeux.nix {};
      retro = with pkgs; retroarch.override {
        cores = with libretro; [
          tic80
        ];
      };
    });
  };
}
