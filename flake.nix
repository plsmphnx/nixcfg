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
  outputs = { self, nixpkgs, ... }: with nixpkgs.lib; {
    nixosModules = updateManyAttrsByPath (
      map (file: {
        path = path.subpath.components
          (removeSuffix ".nix" (path.removePrefix ./modules file));
        update = _: let
          mod = import file;
        in if builtins.isFunction mod then ({
          config, lib, options, pkgs, # default
          flakes, host, user, ...     # special
        } @ args: mod (args // self)) else mod;
      }) (filesystem.listFilesRecursive ./modules)
    ) {};
    packages = mapAttrs (_: pkgs:
      pkgs.lib.packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage;
        directory = ./packages;
      }
    ) nixpkgs.legacyPackages;
  };
}
