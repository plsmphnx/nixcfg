{
  inputs = {
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
      gaming = import ./modules/gaming.nix inputs;
      laptop = import ./modules/laptop.nix;
      login = import ./modules/login.nix;
      msft = import ./modules/msft.nix;
      pc = import ./modules/pc.nix;
      ux = import ./modules/ux.nix inputs;

      flatpak = import ./modules/library/flatpak.nix;
      hibernate = import ./modules/library/hibernate.nix;

      blade = import ./modules/system/blade.nix inputs;
      deck = import ./modules/system/deck.nix inputs;
      gpd = import ./modules/system/gpd.nix inputs;
      pine = import ./modules/system/pine.nix inputs;
      surface = import ./modules/system/surface.nix inputs;
    };
    packages = systems (pkgs: with pkgs; {
      megazeux = callPackage ./packages/megazeux.nix {};
      rustenv = callPackage ./packages/rustenv.nix {};
      steamdeck-dkms = linuxPackages_latest.callPackage
        ./packages/steamdeck-dkms.nix {}; # For testing only.
    });
  };
}
