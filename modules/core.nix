{ config, pkgs, inputs, lib, ... }: let
  sh = pkgs.runCommandLocal "sh" { meta.priority = -1; } ''
    mkdir -p $out/bin
    ln -s ${lib.getExe pkgs.dash} $out/bin/sh
  '';
  os-util = pkgs.writeScriptBin "os"
    (builtins.readFile ../tools/os.sh);
in {
  # system
  system.stateVersion = config.system.nixos.release;
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
      trusted-users = [ "@wheel" ];
      use-cgroups = true;
    };
    registry = builtins.mapAttrs
      (input: _: { flake = inputs."${input}"; }) inputs;
  };
  time.timeZone = "America/Los_Angeles";
  systemd.coredump.enable = false;
  networking.nftables.enable = true;
  hardware.enableAllFirmware = true;
  virtualisation.podman.enable = true;
  boot = {
    enableContainers = false;
    initrd.systemd.enable = true;
  };

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
      os-util
      ouch
      pass
      sh
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
