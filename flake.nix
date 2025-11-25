{
  inputs = {
    exec-util = {
      url = "github:plsmphnx/exec-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypr = {
      url = "github:plsmphnx/hypr";
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

    gpdfan = {
      url = "github:cryolitia/gpd-fan-driver";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, ... } @ inputs: {
    nixosModules = {
      core = import ./modules/core.nix;
      edge = import ./modules/edge.nix;
      gaming = import ./modules/gaming.nix inputs;
      laptop = import ./modules/laptop.nix;
      login = import ./modules/login.nix;
      msft = import ./modules/msft.nix;
      pc = import ./modules/pc.nix;
      ux = import ./modules/ux.nix inputs;

      razer = import ./modules/hardware/razer.nix;

      blade = import ./modules/system/blade.nix inputs;
      gpd = import ./modules/system/gpd.nix inputs;
      pine = import ./modules/system/pine.nix inputs;
      surface = import ./modules/system/surface.nix inputs;
    };
    packages = nixpkgs.lib.mapAttrs (_: pkgs:
      pkgs.lib.packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage;
        directory = ./packages;
      }
    ) nixpkgs.legacyPackages;
  };
}
