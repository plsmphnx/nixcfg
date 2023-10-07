{ hyprland, nixpkgs-wayland, ... }: { config, lib, pkgs, ... }: let
  dbus-run-session = "${pkgs.dbus}/bin/dbus-run-session";
  cage = lib.getExe pkgs.cage;
  gtkgreet = lib.getExe pkgs.greetd.gtkgreet;
  graphite-theme = (graphite-gtk-theme.override {
    sizeVariants = [ "compact" ];
    tweaks = [ "rimless" ];
  });
  graphite-css = "${graphite-theme}/share/themes/Graphite-Dark-compact/gtk-3.0/gtk.css";
in {
  nix.settings = {
    substituters = [
      "https://nixpkgs-wayland.cachix.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

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
    graphite-theme
    tela-icon-theme
      
    hyprland-autoname-workspaces
    nixpkgs-wayland.packages.${system}.waybar
  ];

  fonts.packages = with pkgs; [
    corefonts
    google-fonts
    (nerdfonts.override {
      fonts = [ "NerdFontsSymbolsOnly" ];
    })
  ];

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
        "${dbus-run-session} ${cage} -s -- ${gtkgreet} -ls ${graphite-css}";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  security = {
    rtkit.enable = true;
    pam.services.swaylock = {};
  };
}
