{ inputs, lib, packages, pkgs, user, ... }: let
  flakes = lib.mapAttrs (_: { packages, ... }: let
    pkg = packages.${pkgs.stdenv.hostPlatform.system};
  in pkg.default or pkg) (inputs // { self = { inherit packages; }; });
in {
  imports = [ inputs.shell.nixosModules.default ];

  environment = {
    systemPackages = with pkgs; with flakes; with self; [
      blueberry
      networkmanagerapplet
      nmgui
      pwvucontrol

      app2unit
      brightnessctl
      grimblast
      playerctl
      wl-clipboard
      xdg-utils

      foot
      imv
      minbrowser
      mpv
      nemo
      pragtical
      wlvncc
      zathura

      ffmpegthumbnailer

      theme.cursor
      theme.icon
      theme.gtk

      exec-util
      hypr.jump
      hypr.mods

      hypridle
      hyprlock
      vlock
    ];
    sessionVariables.NIXOS_OZONE_WL = "1";
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
    shell.enable = true;
    wayvnc.enable = true;
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

  hardware.graphics.enable = true;
}
