{ config, host, inputs, lib, pkgs, user, ... }: let
  sh = pkgs.runCommandLocal "sh" { meta.priority = -1; } ''
    mkdir -p $out/bin
    ln -s ${lib.getExe pkgs.dash} $out/bin/sh
  '';
  os = pkgs.writeScriptBin "os" (lib.readFile ../tools/os.sh);
in {
  imports = [ ./library/systemd-user.nix ];

  networking.hostName = host;

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
      trusted-users = [ "@wheel" ];
      use-cgroups = true;
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    registry = lib.mapAttrs (_: flake: { inherit flake; }) inputs;
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = config.system.nixos.release;

  virtualisation.podman.enable = true;
  systemd = {
    coredump.enable = false;
    services."user@".serviceConfig.UMask = "0027";
    user.path = [
      "/run/wrappers/bin"
      "/run/current-system/sw/bin"
      "%h/.nix-profile/bin"
      "%h/.local/bin"
    ];
  };

  environment = {
    etc = {
      "grc.zsh".source = "${pkgs.grc}/etc/grc.zsh";
      "grc.conf".source = "${pkgs.grc}/etc/grc.conf";
    };
    extraInit = ''
      umask 027
    '';
    systemPackages = with pkgs; [
      bat
      btop
      ffmpeg-headless
      file
      gcc
      glib
      grc
      jaq
      libqalculate
      os
      ouch
      pass
      sh
      tzupdate
      whois
    ];
  };

  programs = {
    git.enable = true;
    gnupg.agent.enable = true;
    nix-ld.enable = true;
    tmux.enable = true;
    zsh.enable = true;
  };

  services = {
    envfs.enable = true;
    gvfs.enable = true;
  };

  users = {
    users.${user} = {
      isNormalUser = true;
      uid = 1000;
      group = user;
      extraGroups = [ "audio" "video" "wheel" ];
      homeMode = "750";
      shell = pkgs.zsh;
    };
    groups.${user}.gid = config.users.users.${user}.uid;
  };
}
