pkgs: pkgs.writeScriptBin "os" ''
  #!/bin/sh
  case $1 in
    up*)
      nix flake update /etc/nixos
      nixos-rebuild switch
      ;;
    clean)
      if [ "$2" = "full" ]; then
        nix profile wipe-history --profile /nix/var/nix/profiles/system
      fi
      nix store gc
      ;;
    user)
      case $2 in
        up*)
          NIXPKGS_ALLOW_UNFREE=1 nix profile upgrade '.*' --no-write-lock-file --impure
          if which flatpak > /dev/null; then
            flatpak update -uy
          fi
          ;;
        clean)
          if [ "$3" = "full" ]; then
            nix profile wipe-history
          fi
          nix store gc
          if which flatpak > /dev/null; then
            flatpak uninstall --unused -uy
          fi
          ;;
        i*)
          shift 2
          NIXPKGS_ALLOW_UNFREE=1 nix profile install "$@" --impure
          ;;
      esac
      ;;
  esac
''
