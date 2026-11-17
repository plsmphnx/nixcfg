{ inputs, lib, packages, pkgs, user, ... }: let
  flakes = lib.mapAttrs (_: { packages, ... }: let
    pkg = packages.${pkgs.stdenv.hostPlatform.system};
  in pkg.default or pkg) (inputs // { self = { inherit packages; }; });
in {
  imports = [ inputs.shell.nixosModules.default ];

  environment = {
    systemPackages = with pkgs; with flakes; with self; [
      # shell
      adw-bluetooth
      networkmanagerapplet
      nmgui
      pwvucontrol

      # cli
      app2unit
      brightnessctl
      exec-util
      playerctl
      vlock
      wl-clipboard
      xdg-utils

      # tools
      electron
      foot
      imv
      mpv
      nemo
      wlvncc
      zathura

      # files
      ffmpegthumbnailer
      gnome-disk-utility

      # functionality
      grimblast
      inhibridge
      swayidle
      swaylock

      # theme
      theme.cursor
      theme.icon
      theme.gtk
    ];
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  fonts = {
    fontconfig.subpixel.rgba = "rgb";
    packages = with pkgs; with flakes; [
      corefonts
      google-fonts
      nerd-fonts.symbols-only
      theme.font
    ];
  };

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    hyprland.enable = true;
    shell.enable = true;
    wayvnc.enable = true;
  };

  services = {
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    printing.enable = true;
    resolved.enable = true;
    speechd.enable = false;
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
    pam.services.swaylock.enableGnomeKeyring = true;
  };
}
