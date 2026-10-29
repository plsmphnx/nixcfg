{ emacsPackagesFor, emacs-nox }: let
  emacs = emacsPackagesFor emacs-nox;
in emacs.emacsWithPackages (epkgs: with epkgs; [
  corfu
  ergoemacs-mode
  treemacs
  treesit-auto
  treesit-grammars.with-all-grammars
  tree-sitter-langs
])
