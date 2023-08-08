{ config, pkgs, ... }:{
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
      eww-wayland
      foot
      i3status-rust
      iwgtk
      imv
      luakit
      mpv
      pavucontrol
      pcmanfm
      swayest-workstyle
      swayidle
      swaylock
      wofi
      wlogout

      (graphite-gtk-theme.override {
        sizeVariants = [ "compact" ];
        tweaks = [ "rimless" ];
      })
    ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -rtc sway";
      };
    };
  };

  fonts.packages = with pkgs; [
    google-fonts
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  services.gvfs.enable = true;

  environment.etc = {
    "dconf/profile/user".text = "service-db:keyfile/user\n";
  };
}
