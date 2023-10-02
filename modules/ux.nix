{ config, pkgs, ... }: {
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      blueberry
      foot
      i3status-rust
      iwgtk
      imv
      lite-xl
      luakit
      mpv
      pavucontrol
      pcmanfm
      swayest-workstyle
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
    ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export GDK_BACKEND=wayland
      export QT_QPA_PLATFORM=wayland
    '';
  };

  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    hyprland-autoname-workspaces
    swaybg
    waybar
  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -rtc sway";
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
