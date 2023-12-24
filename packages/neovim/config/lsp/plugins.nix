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
    version = "unstable-2023-11-08";
    src = fetchFromGitHub {
      owner = "ThePrimeagen";
      repo = "refactoring.nvim";
      rev = "156532476deb10b1b2a32cb38e1078b3f9951c42";
      sha256 = "03xgyfzb2jsz7788k5h122jskq90irgg0m12csbrb2ysd727pyf8";
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
