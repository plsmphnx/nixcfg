{ ags, hyprland, hypridle, hyprlock, ... }: { config, lib, pkgs, ... }: let
  dbus-run-session = "${pkgs.dbus}/bin/dbus-run-session";

  cage = lib.getExe pkgs.cage;

  gtkgreet = lib.getExe pkgs.greetd.gtkgreet;

  fluent-icons = pkgs.fluent-icon-theme.override {
    colorVariants = [ "grey" ];
    roundedIcons = true;
  };

  fluent-theme = (pkgs.fluent-gtk-theme.overrideAttrs (_: {
    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "fluent-gtk-theme";
      rev = "e01ae5d9ebc96b9dd235d34aebd78a68e09f8f51";
      hash = "sha256-GFw1aMpDppkgoY4OQ84NgPCk0yF5aInsaysEHaItgVA=";
    };

    preInstall = ''
      substituteInPlace ./src/_sass/_colors.scss \
        --replace-fail "@return white;" "@return rgba(white, 0.9);" \
        --replace-fail "#333333" "#000000" \
        --replace-fail "0.85, 0.5" "0.85, 0.4"
      substituteInPlace ./src/_sass/_variables.scss \
        --replace-fail "8px, 3px" "0px, 0px"
    '';
  })).override {
    colorVariants = [ "dark" ];
    sizeVariants = [ "compact" ];
    themeVariants = [ "grey" ];
    tweaks = [ "blur" "noborder" "round" ];
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
      kanshi
      l3afpad
      lite-xl
      luakit
      mpv
      networkmanagerapplet
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
    dbus.implementation = "broker";

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
