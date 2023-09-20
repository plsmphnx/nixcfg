{ config, pkgs, inputs, ... }: let
  grcfix = pkgs.runCommandLocal "grc.conf" {
    "in" = "${pkgs.grc}/etc/grc.conf";
  } ''
    substitute $in $out \
      --replace '^([/\w\.]+\/)?' '^([/\w\.-]+\/)?'
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

  # Packages
  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    etc = {
      "grc.zsh".source = "${pkgs.grc}/etc/grc.zsh";
      "grc.conf".source = "${grcfix}";
    };
    systemPackages = with pkgs; [
      grc
      highlight
      jq
      pass
      wget
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
