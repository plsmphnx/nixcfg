{ lib, pkgs, ... }: {
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "Hyprland";
        user = "clecompt";
      };
      default_session = initial_session;
    };
  };
}
