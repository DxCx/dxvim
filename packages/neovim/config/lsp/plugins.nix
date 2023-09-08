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
    version = "unstable-2023-08-26";
    src = fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "playground";
      rev = "429f3e76cbb1c59fe000b690f7a5bea617b890c0";
      sha256 = "1flqiycr7dm4cyp2gpy3dmkk8xcdk4268kgmp5qz43qf7fi8m7iy";
    };
  };
  refactoring-nvim = vimUtils.buildVimPluginFrom2Nix {
    pname = "refactoring-nvim";
    version = "unstable-2023-08-31";
    src = fetchFromGitHub {
      owner = "ThePrimeagen";
      repo = "refactoring.nvim";
      rev = "2ec9bc0fb5f3c8c6a0f776f0159dd2a3b1663554";
      sha256 = "038cczxj9ba3axb3aw5r2dsp5anzacnwnnp61i1pk7kk8l3wg2ck";
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
