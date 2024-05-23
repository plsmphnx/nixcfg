{ ags, hyprland, hypridle, hyprlock, ... }: { config, lib, pkgs, ... }: let
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
      hash = "sha256-fnTR79VaQrrpKj09TiNNeX4X9zQlpjvjg5+yHXl02w8=";
    };
    cargoDeps = drv.cargoDeps.overrideAttrs (lib.const {
      inherit src;
      outputHash = "sha256-Fyst6rwpvVQoeWCOkJwpNuMcnp6Q+kAXtDg+fccTVNM=";
    });
  });

  nerdfonts-symbols = pkgs.nerdfonts.override {
    fonts = [ "NerdFontsSymbolsOnly" ];
  };

  systemd-path = builtins.concatStringsSep ":" (map
    (p: (builtins.replaceStrings [ "$HOME" "$USER" ] [ "%h" "%u" ] p) + "/bin")
    config.environment.profiles
  );
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
      l3afpad
      lite-xl
      luakit
      mpv
      pcmanfm
      qalculate-gtk
      zathura

      fluent-icons
      fluent-theme
      vimix-cursors
      
      ags.packages.${system}.agsWithTypes
      hypridle.packages.${system}.hypridle
      hyprlock.packages.${system}.hyprlock
      hyprnome-empty
      kanshi

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
      settings = rec {
        initial_session = {
          command = "Hyprland";
          user = "clecompt";
        };
        default_session = initial_session;
      };
    };

    gnome.gnome-keyring.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  security = {
    rtkit.enable = true;
    pam.services.hyprlock.enableGnomeKeyring = true;
  };

  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=${systemd-path}"
  '';

  qt = {
    enable = true;
    style = "kvantum";
  };
}
