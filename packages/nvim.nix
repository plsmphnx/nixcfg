{
  neovim-unwrapped,
  vimPlugins,
  wrapNeovimUnstable,
}: wrapNeovimUnstable neovim-unwrapped {
  wrapRc = false;
  waylandSupport = false;
  plugins = with vimPlugins; [
    base46
    gitsigns-nvim
    nvchad-ui
    nvim-lspconfig
    nvim-tree-lua
    nvim-treesitter.withAllGrammars
    nvim-web-devicons
    snacks-nvim
  ];
}
