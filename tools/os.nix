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
          nix profile upgrade '.*' --no-write-lock-file
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
      esac
      ;;
  esac
'';
