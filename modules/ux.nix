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

  programs = {
    hyprland = {
      enable = true;
      package = hyprland.packages.${pkgs.system}.hyprland;
    };
    regreet = {
      enable = true;
      settings = {
        GTK = {
          application_prefer_dark_theme = true;
          cursor_theme_name = "graphite-dark";
          font_name = "Noto Sans Mono 14";
          icon_theme_name = "Tela-grey-dark";
          theme_name = "Graphite-Dark-compact";
        };
      };
    };
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
    nixpkgs-wayland.packages.${system}.waybar
  ];

  fonts = {
    fontconfig.subpixel.rgba = "rgb";
    packages = with pkgs; [
      corefonts
      google-fonts
      (nerdfonts.override {
        fonts = [ "NerdFontsSymbolsOnly" ];
      })
    ];
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    flatpak.enable = true;
    gvfs.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  security = {
    rtkit.enable = true;
    pam.services.swaylock = {};
  };
}
