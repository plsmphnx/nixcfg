#!/bin/sh
if [ $(id -u) = 0 ]; then
  case $1 in
    u*)
      if [ -n "$2" ]; then
        nix flake update --flake /etc/nixos
      fi
      if echo "$2" | grep -q "@"; then
        nixos-rebuild switch --fast --impure --use-substitutes --build-host "$2"
      else
        nixos-rebuild switch --fast --impure
      fi
      ;;
    c*)
      if [ "$2" = "full" ]; then
        nix profile wipe-history --profile /nix/var/nix/profiles/system
      fi
      nix store gc
      ;;
  esac
else
  case $1 in
    u*)
      NIXPKGS_ALLOW_UNFREE=1 nix profile upgrade --all --no-write-lock-file --impure
      if command -v flatpak 2>&1 >/dev/null; then
        flatpak update -uy
      fi
      ;;
    c*)
      if [ "$2" = "full" ]; then
        nix profile wipe-history
      fi
      nix store gc
      if command -v flatpak 2>&1 >/dev/null; then
        flatpak uninstall --unused -uy
      fi
      ;;
    i*)
      shift 1
      NIXPKGS_ALLOW_UNFREE=1 nix profile install "$@" --no-write-lock-file --impure
      ;;
  esac
fi
