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
    hover-nvim
    lualine-nvim
    nvim-lspconfig
    nvim-tree-lua
    nvim-treesitter.withAllGrammars
    nvim-web-devicons
    transparent-nvim
    vscode-nvim
  ];
}
