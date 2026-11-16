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
    nvim-lspconfig
    nvim-treesitter.withAllGrammars
    snacks-nvim
    vscode-nvim
  ];
}
