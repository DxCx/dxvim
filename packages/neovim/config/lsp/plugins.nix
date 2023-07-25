{ vimPlugins
, vimUtils
, callPackage
, fetchFromGitHub
, ...
}:
let
  nvim-treesitter = callPackage ./treesitter.nix { };

  tree-sitter-playground = vimUtils.buildVimPluginFrom2Nix {
    pname = "tree-sitter-playground";
    version = "unstable-2023-04-15";
    src = fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "playground";
      rev = "2b81a018a49f8e476341dfcb228b7b808baba68b";
      sha256 = "1b7h4sih8dc55w12f0v5knk9cxfpy0iffhbvmg0g84if55ar616v";
    };
  };
  refactoring-nvim = vimUtils.buildVimPluginFrom2Nix {
    pname = "refactoring-nvim";
    version = "unstable-2023-07-26";
    src = fetchFromGitHub {
      owner = "ThePrimeagen";
      repo = "refactoring.nvim";
      rev = "5359e74291164fcaeaaecdea9ba753ad54eb53d0";
      sha256 = "1jskfd63n3r1slwhbv1qv239nd0mp3q7h4r9fardkc4xf7nsy1jb";
    };
  };
in
with vimPlugins; [
  # Syntax
  nvim-ts-rainbow2
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
