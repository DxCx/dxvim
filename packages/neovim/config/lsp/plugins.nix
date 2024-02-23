{ vimPlugins, vimUtils, callPackage, fetchFromGitHub, ... }:
let
  nvim-treesitter = callPackage ./treesitter.nix { };
  lspecho =
    vimUtils.buildVimPlugin { # echo lsp background progress to statusline
      pname = "lspecho-nvim";
      version = "unstable-2024-02-21";
      src = fetchFromGitHub {
        owner = "deathbeam";
        repo = "lspecho.nvim";
        rev = "c13b1d7a1550275c1f6240eb2005ba8729dbc6e8";
        sha256 = "15p9yw4vzz3kl9bhaqf6cq0d4cn1c4ahpp6p4y4k4pn1dadbm1a5";
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
    version = "unstable-2024-02-18";
    src = fetchFromGitHub {
      owner = "ThePrimeagen";
      repo = "refactoring.nvim";
      rev = "1b593e7203b31c7bde3fa638e6869144698df3b6";
      sha256 = "0q0xbn5xxh4fyjm5v2c2pvai9djyk67xk2brqn209sx3qq8drs5n";
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
