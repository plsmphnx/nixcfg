{
  inputs = {
    nixpkgs.url  = "github:nixos/nixpkgs/nixos-unstable";
    ags.url      = "github:aylur/ags";
    hyprland.url = "git+https://github.com/hyprwm/hyprland?submodules=1";
    hypridle.url = "git+https://github.com/hyprwm/hypridle?submodules=1";
    hyprlock.url = "git+https://github.com/hyprwm/hyprlock?submodules=1";
  };
  outputs = { self, nixpkgs, ... } @ inputs: let
    systems = fn: nixpkgs.lib.mapAttrs (_: fn) nixpkgs.legacyPackages;
  in {
    nixosModules = {
      core = import ./modules/core.nix;
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
