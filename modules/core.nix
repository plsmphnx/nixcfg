{ config, host, pkgs, inputs, lib, user, ... }: let
  sh = pkgs.runCommandLocal "sh" { meta.priority = -1; } ''
    mkdir -p $out/bin
    ln -s ${lib.getExe pkgs.dash} $out/bin/sh
  '';
  os = pkgs.writeScriptBin "os" (builtins.readFile ../tools/os.sh);
in {
  # system
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
    };
    registry = builtins.mapAttrs (input: flake: { inherit flake; }) inputs;
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = config.system.nixos.release;

  boot = {
    enableContainers = false;
    initrd.systemd.enable = true;
  };
  networking = {
    hostName = host;
    nftables.enable = true;
  };
  hardware.enableAllFirmware = true;

  time.timeZone = "America/Los_Angeles";
  systemd.coredump.enable = false;
  virtualisation.podman.enable = true;

  # packages
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
      grc
      jq
      libqalculate
      os
      ouch
      pass
      sh
      trashy
      wget
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

  services.envfs.enable = true;

  # user
  users = {
    users.${user} = {
      isNormalUser = true;
      uid = 1000;
      group = user;
      extraGroups = [ "audio" "video" "wheel" ];
      homeMode = "750";
      shell = pkgs.zsh;
    };
    groups.${user} = {
      gid = 1000;
    };
  };
}
