{
  neovim-unwrapped,
  vimPlugins,
  wrapNeovimUnstable,
}: let
  plugins = vimPlugins.extend (_: prev: {
    nvim-treesitter-legacy = prev.nvim-treesitter.withAllGrammars;
  });
in wrapNeovimUnstable neovim-unwrapped {
  wrapRc = false;
  waylandSupport = false;
  plugins = with plugins; [
    base46
    nvchad
    nvim-tree-lua
    nvim-web-devicons
    nvzone-menu
    plenary-nvim
  ];
}
