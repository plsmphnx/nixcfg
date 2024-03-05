{ ags, hyprland, hypridle, hyprlock, ... }: { config, lib, pkgs, ... }: let
  dbus-run-session = "${pkgs.dbus}/bin/dbus-run-session";

  cage = lib.getExe pkgs.cage;

  gtkgreet = lib.getExe pkgs.greetd.gtkgreet;

  fluent-icons = pkgs.fluent-icon-theme.override {
    colorVariants = [ "grey" ];
    roundedIcons = true;
  };

  fluent-theme = pkgs.fluent-gtk-theme.override {
    colorVariants = [ "dark" ];
    sizeVariants = [ "compact" ];
    themeVariants = [ "grey" ];
    tweaks = [ "blur" "noborder" ];
  };

  fluent-css = "${fluent-theme}/share/themes/Fluent-grey-Dark-compact/gtk-3.0/gtk.css";

  imv-safe = pkgs.imv.override {
    withBackends = [ "libtiff" "libjpeg" "libpng" "librsvg" "libheif" ];
  };

  nerdfonts-symbols = pkgs.nerdfonts.override {
    fonts = [ "NerdFontsSymbolsOnly" ];
  };
in {
  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      blueberry
      foot
      iwgtk
      imv-safe
      l3afpad
      lite-xl
      luakit
      mpv
      pavucontrol
      pcmanfm
      zathura

      fluent-icons
      fluent-theme
      vimix-cursors
      
      ags.packages.${system}.agsWithTypes
      hypridle.packages.${system}.hypridle
      hyprlock.packages.${system}.hyprlock
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

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    flatpak.enable = true;

    gvfs.enable = true;

    greetd = {
      enable = true;
      settings.default_session.command =
        "${dbus-run-session} ${cage} -s -- ${gtkgreet} -l -s ${fluent-css} -c Hyprland";
    };

    gnome.gnome-keyring.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  security = {
    rtkit.enable = true;
    pam.services.hyprlock = {};
  };
}
