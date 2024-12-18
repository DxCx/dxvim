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
    version = "unstable-2024-11-30";
    src = fetchFromGitHub {
      owner = "deathbeam";
      repo = "lspecho.nvim";
      rev = "8817eef7ebeb518341c621091c21946f547034c8";
      sha256 = "02g3b7ymgzrv95g4kxc58kydldikynw92ks519rznciw1ddl0s2d";
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
    version = "unstable-2024-11-19";
    src = fetchFromGitHub {
      owner = "ThePrimeagen";
      repo = "refactoring.nvim";
      rev = "2db6d378e873de31d18ade549c2edba64ff1c2e3";
      sha256 = "1q79i3x21vv8kz0b456w6v5zda6jc6k4z0jbfijls8h4hvkj7j39";
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
