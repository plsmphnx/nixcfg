{ config, pkgs, inputs, ... }: {
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
      trusted-users = [ "@wheel" ];
      use-cgroups = true;
    };
    registry = builtins.mapAttrs
      (input: _: { flake = inputs."${input}"; }) inputs;
  };
  time.timeZone = "America/Los_Angeles";
  systemd.coredump.enable = false;

  # Packages
  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    etc = {
      "grc.zsh".source = "${pkgs.grc}/etc/grc.zsh";
      "grc.conf".source = "${pkgs.grc}/etc/grc.conf";
    };
    extraInit = ''
      umask 027
    '';
    systemPackages = with pkgs; [
      grc
      highlight
      jq
      libqalculate
      pass
      wget

      (import ../tools/os.nix pkgs)
    ];
  };
  programs = {
    git.enable = true;
    gnupg.agent.enable = true;
    nix-ld.enable = true;
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
