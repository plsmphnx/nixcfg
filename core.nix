{ config, pkgs, ... }:{
  # System
  system.stateVersion = "unstable";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  time.timeZone = "America/Los_Angeles";

  # Packages
  environment.systemPackages = with pkgs; [
    grc
    highlight
    wget
  ];
  programs.git.enable = true;
  programs.tmux.enable = true;
  programs.zsh.enable = true;
  services.envfs.enable = true;

  # User
  users.users.clecompt = {
    isNormalUser = true;
    extraGroups = [ "audio" "video" "wheel" ];
    shell = pkgs.zsh;
  };
}
