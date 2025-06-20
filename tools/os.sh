#!/bin/sh
if [ $(id -u) = 0 ]; then
  OPT="--no-reexec --impure"
  case $1 in
    u*)
      if [ "$2" != "-" ]; then
        nix flake update --flake /etc/nixos
      fi
      if echo "$2" | grep -q "@"; then
        nixos-rebuild switch $OPT --use-substitutes --build-host "$2"
      else
        nixos-rebuild switch $OPT
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
  export NIXPKGS_ALLOW_UNFREE=1
  OPT="--no-write-lock-file --impure --inputs-from /etc/nixos"
  case $1 in
    u*)
      nix profile upgrade --all $OPT
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
      nix profile install "$@" $OPT
      ;;
    l*)
      nix profile list | sed -En 's/Name: +(.*)/\1/p'
      ;;
  esac
fi
