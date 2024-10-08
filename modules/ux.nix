inputs: { config, lib, pkgs, ... }: let
  flakes = lib.mapAttrs
    (_: flake: flake.packages.${pkgs.system}.default or null) inputs;

  fluent-icons = pkgs.fluent-icon-theme.override {
    colorVariants = [ "grey" ];
    roundedIcons = true;
  };

  fluent-theme = (pkgs.fluent-gtk-theme.overrideAttrs (_: {
    preInstall = ''
      sed -i "/primary/s/white/rgba(white, 0.9)/g" ./src/_sass/_colors.scss
      sed -i "/\$background:/s/#333333/#000000/gi" ./src/_sass/_colors.scss
      sed -i "/\$surface:/s/#3C3C3C/#000000/gi" ./src/_sass/_colors.scss
      sed -i "/\$blur_opacity:/s/0\.5/0.4/g" ./src/_sass/_colors.scss
      sed -i "/\$window-radius:/s/.px/0px/g" ./src/_sass/_variables.scss    
    '';
  })).override {
    colorVariants = [ "dark" ];
    sizeVariants = [ "compact" ];
    themeVariants = [ "grey" ];
    tweaks = [ "blur" "noborder" "round" ];
  };

  hyprnome-empty = pkgs.hyprnome.overrideAttrs (drv: rec {
    src = pkgs.fetchFromGitHub {
      owner = "plsmphnx";
      repo = "hyprnome";
      rev = "empty";
      hash = "sha256-pFx+Kj7dFxE63/hOYeItUPwEP22i4w9yiivAm1A9M0Q=";
    };
    cargoDeps = drv.cargoDeps.overrideAttrs (lib.const {
      inherit src;
      outputHash = "sha256-LmHWV5Ps2YRXfAnhO+a0o6VpS3/4gsmto2J6oQb4Csw=";
    });
  });

  nerdfonts-symbols = pkgs.nerdfonts.override {
    fonts = [ "NerdFontsSymbolsOnly" ];
  };
in {
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      blueberry
      iwgtk
      networkmanagerapplet
      pavucontrol

      brightnessctl
      grimblast
      pamixer
      playerctl
      xdg-utils

      foot
      imv
      lite-xl
      luakit
      mpv
      pcmanfm
      qalculate-gtk
      zathura

      fluent-icons
      fluent-theme
      vimix-cursors
      
      flakes.ags
      flakes.exec-util
      flakes.hyprmks

      hyprlock
      hyprnome-empty
      shikane
      vlock

      ffmpegthumbnailer
      kdePackages.qtwayland
      libsForQt5.qt5.qtwayland
    ];
  };

  fonts = {
    fontconfig.subpixel.rgba = "rgb";
    packages = with pkgs; [
      corefonts
      google-fonts
      nerdfonts-symbols
    ];
  };

  programs.hyprland.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    flatpak.enable = true;
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    systemd-lock-handler.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  security = {
    rtkit.enable = true;
    pam.services.hyprlock.enableGnomeKeyring = true;
  };

  qt = {
    enable = true;
    style = "kvantum";
  };
}
