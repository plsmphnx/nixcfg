{
  neovim-unwrapped,
  vimPlugins,
  wrapNeovimUnstable,
}: wrapNeovimUnstable neovim-unwrapped {
  wrapRc = false;
  waylandSupport = false;
  plugins = with vimPlugins; [
    barbar-nvim
    gitsigns-nvim
    nvim-lspconfig
    nvim-tree-lua
    nvim-treesitter.withAllGrammars
    nvim-web-devicons
    vscode-nvim
  ];
}
