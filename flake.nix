{
  inputs = {
    nixpkgs.url  = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "git+https://github.com/hyprwm/hyprland?submodules=1";
    hypridle.url = "git+https://github.com/hyprwm/hypridle?submodules=1";
    hyprlock.url = "git+https://github.com/hyprwm/hyprlock?submodules=1";
    xdph.url = "git+https://github.com/hyprwm/xdg-desktop-portal-hyprland?submodules=1";
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
    });
  };
}
