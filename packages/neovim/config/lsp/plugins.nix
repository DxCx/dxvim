{
  vimPlugins,
  vimUtils,
  callPackage,
  fetchFromGitHub,
  ...
}:
let
  nvim-treesitter = callPackage ./treesitter.nix { };
  lspecho = vimUtils.buildVimPlugin {
    # echo lsp background progress to statusline
    pname = "lspecho-nvim";
    version = "unstable-2024-02-28";
    src = fetchFromGitHub {
      owner = "deathbeam";
      repo = "lspecho.nvim";
      rev = "5aab80359269f0c70010f50464a6df0d0c318c08";
      sha256 = "156n5v2rbbpkvahvgh2f3d4d0130cknbwxa010clvz65q0km1fh7";
    };
  };
  tree-sitter-playground = vimUtils.buildVimPlugin {
    pname = "tree-sitter-playground";
    version = "unstable-2023-09-15";
    src = fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "playground";
      rev = "ba48c6a62a280eefb7c85725b0915e021a1a0749";
      sha256 = "1vgj5vc32ly15ni62fk51yd8km2zp3fkzx0622x5cv9pavmjpr40";
    };
  };
  refactoring-nvim = vimUtils.buildVimPlugin {
    pname = "refactoring-nvim";
    version = "unstable-2024-06-22";
    src = fetchFromGitHub {
      owner = "ThePrimeagen";
      repo = "refactoring.nvim";
      rev = "c9c1a0995b7d9a534f3b9a4df7fd55240127eeb4";
      sha256 = "1fajahgd20cn75xaz4qq0dhvqr2rqr788l874n9qvk4mq4qqvnj2";
    };
  };
in
with vimPlugins;
[
  # Syntax
  rainbow-delimiters-nvim
  nvim-treesitter
  tree-sitter-playground
  vim-illuminate

  # Basic LSP & utilites related
  nvim-lspconfig
  null-ls-nvim
  lsp-colors-nvim
  trouble-nvim
  lspecho

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
