{
  neovim-unwrapped,
  vimPlugins,
  wrapNeovimUnstable,
}: wrapNeovimUnstable neovim-unwrapped {
  wrapRc = false;
  waylandSupport = false;
  plugins = with vimPlugins; [
    guess-indent-nvim
    lualine-nvim
    mini-nvim
    neo-tree-nvim
    nvim-lspconfig
    nvim-treesitter.withAllGrammars
    vscode-nvim
  ];
}
