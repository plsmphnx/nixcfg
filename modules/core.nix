{ config, flakes, host, lib, outputs, pkgs, user, ... }: let
  os = pkgs.writeScriptBin "os" (lib.readFile ../tools/os.sh);
in {
  imports = with outputs.nixosModules.library; [ environment systemd-user ];

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
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakes;
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = config.system.nixos.release;

  virtualisation.podman.enable = true;
  systemd = {
    coredump.extraConfig = "Storage=journal";
    user = {
      env.PATH = lib.mkBefore
        "/run/wrappers/bin:/run/current-system/sw/bin:%h/.nix-profile/bin:%h/.local/bin";
      umask = "027";
    };
  };

  environment = {
    alias = {
      jq = lib.getExe pkgs.jaq;
      sh = lib.getExe pkgs.dash;
      wget = lib.getExe' pkgs.curl "wcurl";
    };
    etc = {
      "grc.zsh".source = "${pkgs.grc}/etc/grc.zsh";
      "grc.conf".source = "${pkgs.grc}/etc/grc.conf";
    };
    systemPackages = with pkgs; [
      bat
      btop
      ffmpeg-headless
      file
      gcc
      glib
      grc
      libqalculate
      os
      ouch
      pass
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
    dbus.implementation = "broker";
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
