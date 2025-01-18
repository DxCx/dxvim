{
  vimPlugins,
  callPackage,
  ...
}:
let
  nvim-treesitter = callPackage ./treesitter.nix { };
in
with vimPlugins;
[
  # Syntax
  rainbow-delimiters-nvim
  nvim-treesitter
  vim-illuminate

  # Basic LSP & utilites related
  plenary-nvim
  nvim-lspconfig
  null-ls-nvim
  lsp-colors-nvim
  trouble-nvim
  lspecho-nvim

  # More lsp actions :)
  refactoring-nvim

  # Snippets
  luasnip

  # Inlay hints
  lsp-inlayhints-nvim

  # Auto complete
  nvim-cmp
  cmp-nvim-lsp
  cmp-nvim-lsp-signature-help
  cmp-nvim-lsp-document-symbol
  cmp-buffer
  cmp-path
  cmp-cmdline
  cmp-cmdline-history
  lspkind-nvim

  # Auto complete for snippets
  cmp_luasnip
]
