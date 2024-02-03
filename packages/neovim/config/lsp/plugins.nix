{ vimPlugins, vimUtils, callPackage, fetchFromGitHub, ... }:
let
  nvim-treesitter = callPackage ./treesitter.nix { };

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
    version = "unstable-2024-01-26";
    src = fetchFromGitHub {
      owner = "ThePrimeagen";
      repo = "refactoring.nvim";
      rev = "aff2e21e2f1a19d302adceb4e7d0fafbb3ae59a9";
      sha256 = "033jlxaz67zx1c5irvdf991cq537b99iksnch7z3661pddfz4f6b";
    };
  };
in with vimPlugins; [
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
