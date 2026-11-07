{
  neovim-unwrapped,
  vimPlugins,
  wrapNeovimUnstable,
}: wrapNeovimUnstable neovim-unwrapped {
  wrapRc = false;
  waylandSupport = false;
  plugins = with vimPlugins; [
    bufferline-nvim
    gitsigns-nvim
    guess-indent-nvim
    hover-nvim
    lualine-nvim
    mini-nvim
    nvim-lspconfig
    nvim-treesitter.withAllGrammars
    snacks-nvim
    trouble-nvim
    vscode-nvim
  ];
}
