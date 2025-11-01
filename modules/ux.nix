inputs: { lib, pkgs, user, ... }: let
  flakes = lib.mapAttrs (_: flake: let
    packages = flake.packages.${pkgs.stdenv.hostPlatform.system};
  in packages.default or packages) inputs;

  mpv = pkgs.mpv.override {
    scripts = [ pkgs.mpvScripts.mpris ];
  };
in {
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      blueberry
      iwgtk
      networkmanagerapplet
      pwvucontrol

      app2unit
      brightnessctl
      grimblast
      playerctl
      xdg-utils

      foot
      imv
      luakit
      mpv
      nemo
      (pragtical.override { mbedtls_2 = mbedtls; })
      qalculate-gtk
      zathura

      flakes.theme.cursor
      flakes.theme.icon
      flakes.theme.gtk

      flakes.exec-util
      flakes.hypr.jump
      flakes.hypr.mods
      flakes.shell

      hypridle
      hyprlock
      vlock

      kdePackages.qtwayland
      libsForQt5.qt5.qtwayland
    ];
  };

  systemd = {
    packages = [ flakes.shell ];
    user.targets.graphical-session.wants = [ "shell.service" ];
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
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    printing.enable = true;
    resolved.enable = true;
    systemd-lock-handler.enable = true;
  };

  networking.networkmanager.enable = true;
  users.users.${user}.extraGroups = [ "networkmanager" ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
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
