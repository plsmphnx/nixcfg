{ config, pkgs, ... }:{
  # System
  system.stateVersion = "unstable";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  time.timeZone = "America/Los_Angeles";

  # Packages
  environment.binsh = "${pkgs.dash}/bin/dash";
  environment.systemPackages = with pkgs; [
    grc
    highlight
    jq
    pass
    wget
  ];
  programs.git.enable = true;
  programs.gnupg.agent.enable = true;
  programs.tmux.enable = true;
  programs.zsh.enable = true;

  # User
  users.users.clecompt = {
    isNormalUser = true;
    extraGroups = [ "audio" "video" "wheel" ];
    shell = pkgs.zsh;
  };
}
