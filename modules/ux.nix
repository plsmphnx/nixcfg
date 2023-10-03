{ hyprland, nixpkgs-wayland, ... }: { config, pkgs, ... }: {
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
  nixpkgs.overlays = [ nixpkgs-wayland.overlay ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # programs.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true;
  #   extraPackages = with pkgs; [
  #     i3status-rust
  #     swayest-workstyle
  #   ];
  #   extraSessionCommands = ''
  #     export SDL_VIDEODRIVER=wayland
  #     export GDK_BACKEND=wayland
  #     export QT_QPA_PLATFORM=wayland
  #   '';
  # };

  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
  };

  environment.systemPackages = with pkgs; [
    blueberry
    foot
    iwgtk
    imv
    lite-xl
    luakit
    mpv
    pavucontrol
    pcmanfm
    swayidle
    swaylock
    swaynotificationcenter
    wofi
    zathura

    graphite-cursors
    (graphite-gtk-theme.override {
      sizeVariants = [ "compact" ];
      tweaks = [ "rimless" ];
    })
    tela-icon-theme
      
    hyprland-autoname-workspaces
    waybar
  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -rtc Hyprland";
      };
    };
  };

  fonts.packages = with pkgs; [
    corefonts
    google-fonts
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  services.gvfs.enable = true;
}
