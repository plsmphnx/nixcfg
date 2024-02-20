{ hyprland, hypridle, nixpkgs-wayland, ... }: { config, lib, pkgs, ... }: let
  dbus-run-session = "${pkgs.dbus}/bin/dbus-run-session";

  cage = lib.getExe pkgs.cage;

  gtkgreet = lib.getExe pkgs.greetd.gtkgreet;

  graphite-theme = (pkgs.graphite-gtk-theme.override {
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
    portalPackage = hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      blueberry
      foot
      iwgtk
      imv
      lite-xl
      luakit
      mpv
      pavucontrol
      pcmanfm
      swaylock
      swaynotificationcenter
      wofi
      zathura

      graphite-cursors
      graphite-theme
      tela-icon-theme
      
      hyprland-autoname-workspaces
      hypridle.packages.${system}.hypridle
      nixpkgs-wayland.packages.${system}.waybar
    ];
  };

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

    greetd = {
      enable = true;
      settings.default_session.command =
        "${dbus-run-session} ${cage} -s -- ${gtkgreet} -l -s ${graphite-css} -c Hyprland";
    };

    gnome.gnome-keyring.enable = true;
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
