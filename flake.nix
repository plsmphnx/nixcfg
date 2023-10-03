{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    hyprland.url = "github:hyprwm/Hyprland";
  };
  outputs = { self, nixpkgs, ... } @ inputs: let
    attrs = k: f: builtins.listToAttrs
      (map (n: { name = n; value = f n; }) k);
  in {
    nixosModules = {
      blade = import ./modules/blade.nix;
      core = import ./modules/core.nix;
      laptop = import ./modules/laptop.nix;
      pbp = import ./modules/pbp.nix;
      ux = import ./modules/ux.nix inputs;
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
