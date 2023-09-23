{ config, inputs, lib, pkgs, ... }: let
  grcfix = pkgs.runCommandLocal "grc.conf" {
    "in" = "${pkgs.grc}/etc/grc.conf";
  } ''
    substitute $in $out \
      --replace '^([/\w\.]+\/)?' '^([/\w\.-]+\/)?'
  '';

  osutil = pkgs.writeScriptBin "os" ''
    #!/bin/sh
    case $1 in
      upgrade)
        nix flake update /etc/nixos
        nixos-rebuild switch
        ;;
      clean)
        if [ $2 = full ]; then
          nix profile wipe-history --profile /nix/var/nix/profiles/system
        fi
        nix store gc
        ;;
      user)
        case $2 in
          upgrade)
            nix profile upgrade '.*' --no-write-lock-file
            ;;
          clean)
            if [ $3 = full ]; then
              nix profile wipe-history
            fi
            nix store gc
            ;;
        esac
        ;;
    esac
  '';
in {
  # System
  system.stateVersion = "unstable";
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "ca-derivations"
        "cgroups"
        "flakes"
        "nix-command"
      ];
      flake-registry = "";
      use-cgroups = true;
    };
    registry = builtins.mapAttrs
      (input: _: { flake = inputs."${input}"; }) inputs;
  };
  time.timeZone = "America/Los_Angeles";
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # Packages
  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    etc = {
      "grc.zsh".source = "${pkgs.grc}/etc/grc.zsh";
      "grc.conf".source = "${grcfix}";
    };
    systemPackages = [
      pkgs.grc
      pkgs.highlight
      pkgs.jq
      pkgs.pass
      pkgs.wget
      osutil
    ];
  };
  programs = {
    git.enable = true;
    gnupg.agent.enable = true;
    tmux.enable = true;
    zsh.enable = true;
  };

  # User
  users = {
    users.clecompt = {
      isNormalUser = true;
      uid = 1000;
      group = "clecompt";
      extraGroups = [ "audio" "video" "wheel" ];
      homeMode = "750";
      shell = pkgs.zsh;
    };
    groups.clecompt = {
      gid = 1000;
    };
  };
}
