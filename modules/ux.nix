inputs: { config, lib, pkgs, ... }: let
  flakes = lib.mapAttrs
    (_: flake: flake.packages.${pkgs.system}.default or null) inputs;

  fluent-icons = pkgs.fluent-icon-theme.override {
    colorVariants = [ "grey" ];
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

  mpv = pkgs.mpv.override {
    scripts = with pkgs.mpvScripts; [ mpris ];
  };
in {
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      blueberry
      iwgtk
      networkmanagerapplet
      pwvucontrol

      brightnessctl
      grimblast
      playerctl
      xdg-utils

      foot
      imv
      lite-xl
      luakit
      mpv
      nemo
      qalculate-gtk
      zathura

      fluent-icons
      fluent-theme
      flakes.vimix-cursors
      
      flakes.exec-util
      flakes.hyprjump
      flakes.hyprmks
      flakes.shell

      hypridle
      hyprlock
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
      nerd-fonts.symbols-only
    ];
  };

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    hyprland.enable = true;
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    printing.enable = true;
    systemd-lock-handler.enable = true;
  };

  networking.networkmanager.enable = true;
  users.users.clecompt.extraGroups = [ "networkmanager" ];

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
