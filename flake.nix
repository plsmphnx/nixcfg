{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    exec-util = {
      url = "github:plsmphnx/exec-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprjump = {
      url = "github:plsmphnx/hyprjump";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprmks = {
      url = "github:plsmphnx/hyprmks";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    shell = {
      url = "github:plsmphnx/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    theme = {
      url = "github:plsmphnx/theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, ... } @ inputs: let
    systems = fn: nixpkgs.lib.mapAttrs (_: fn) nixpkgs.legacyPackages;
  in {
    nixosModules = {
      core = import ./modules/core.nix;
      edge = import ./modules/edge.nix;
      gaming = import ./modules/gaming.nix;
      laptop = import ./modules/laptop.nix;
      login = import ./modules/login.nix;
      msft = import ./modules/msft.nix;
      pc = import ./modules/pc.nix;
      ux = import ./modules/ux.nix inputs;

      blade = import ./modules/system/blade.nix inputs;
      deck = import ./modules/system/deck.nix inputs;
      pbp = import ./modules/system/pbp.nix inputs;
      surface = import ./modules/system/surface.nix inputs;
    };
    packages = systems (pkgs: {
      megazeux = pkgs.callPackage ./packages/megazeux.nix {};
      rustenv = pkgs.callPackage ./packages/rustenv.nix {};
      steamdeck-dkms = pkgs.linuxPackages_latest.callPackage
        ./packages/steamdeck-dkms.nix {}; # For testing only.
    });
  };
}
