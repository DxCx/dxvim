{ lib
, pkgs
, vimPlugins
, vimUtils
, fetchFromGitHub
, tree-sitter
, callPackage
, ...
}:

let
  icon-picker = vimUtils.buildVimPluginFrom2Nix {
    pname = "icon-picker.nvim";
    version = "unstable-2022-09-03";
    src = fetchFromGitHub {
      owner = "ziontee113";
      repo = "icon-picker.nvim";
      rev = "0f3b2648f6f8e788bc8dfe37bc9bb18b565cfc3c";
      sha256 = "15zygdg8g8jf1n75nclrbddvp9fz8k4jiczv0amgc7x1dy46cbvy";
    };
  };
  prettier-nvim = vimUtils.buildVimPluginFrom2Nix {
    pname = "prettier.nvim";
    version = "unstable-2022-11-14";
    src = fetchFromGitHub {
      owner = "MunifTanjim";
      repo = "prettier.nvim";
      rev = "6f19a4f68e7cce31a244c9479d47cce0c2a8f135";
      sha256 = "1dh29q778b58rvyhqidfixs7gx0n40y650k8jgj2iq4674frxmvj";
    };
  };
  tree-sitter-playground = vimUtils.buildVimPluginFrom2Nix {
    pname = "tree-sitter-playground";
    version = "unstable-2022-11-26";
    src = fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "playground";
      rev = "1290fdf6f2f0189eb3b4ce8073d3fda6a3658376";
      sha256 = "1yznmc5a32b4bw0c9q0jfkbd77xmi7rmihfr0f44bcgqdxlp8151";
    };
  };
  dbsession-nvim = vimUtils.buildVimPluginFrom2Nix {
    pname = "dbsession.nvim";
    version = "unstable-2023-05-31";
    src = fetchFromGitHub {
      owner = "nvimdev";
      repo = "dbsession.nvim";
      rev = "8a9d15244190e5f191beef03d50f988e5077446c";
      sha256 = "12yrmnphspb3nyrsgvmp5m270k5hkw1gna904ypl90smskc4wiyx";
    };
  };
  # Telescope integration to Nix docs
  telescope-manix = vimUtils.buildVimPluginFrom2Nix {
    pname = "telescope-manix";
    version = "unstable-2022-10-10";
    src = fetchFromGitHub {
      owner = "mrcjkb";
      repo = "telescope-manix";
      rev = "b254c28d7d793fe93cfaccf9bd53493a0c579e3b";
      sha256 = "059qfrvd7bigqkkjc5g6wdrzb7a7x37xxnx99hx236sxraihaka7";
    };
  };
  dotbox-nvim = vimUtils.buildVimPluginFrom2Nix {
    pname = "dotbox.nvim";
    version = "unstable-2022-11-26";
    src = fetchFromGitHub {
      owner = "jakehamilton";
      repo = "dotbox.nvim";
      rev = "4d6eaee93f7a890a0ef5d993ff00a05af48c1374";
      sha256 = "0s65xsrqkjdy4zmqxh2gn17kh1d2b7w2jvwa6hrrw1nag4h6cids";
    };
  };
in
with vimPlugins; [
  # Icons
  nvim-web-devicons

  # Syntax
  nvim-ts-rainbow2
  (nvim-treesitter.withPlugins
    (plugins: tree-sitter.allGrammars))
  tree-sitter-playground
  nvim-treesitter-context

  # Utility
  plenary-nvim
  vim-bufkill
  neodev-nvim
  dressing-nvim

  # Telescope
  telescope-nvim
  telescope-symbols-nvim
  telescope-project-nvim

  # Language Server
  nvim-lspconfig
  null-ls-nvim
  lsp-colors-nvim
  trouble-nvim
  prettier-nvim
  mason-nvim
  mason-lspconfig-nvim

  # Autocomplete
  nvim-cmp
  cmp-nvim-lsp

  # Snippets
  luasnip
  cmp_luasnip

  # Direnv
  direnv-vim

  # Text Manipulation
  vim-repeat
  vim-surround
  vim-commentary

  # Movement
  hop-nvim # TODO: Previously used vim-easymotion
  neoscroll-nvim

  # File Browser
  nvim-tree-lua

  # Editor Configuration
  editorconfig-nvim

  # Highlighting & View Augmentation
  vim-illuminate
  todo-comments-nvim
  delimitMate
  twilight-nvim

  # Theme
  NeoSolarized # TODO: Previously used oceanic-next

  # Status Line & Buffer Line # TODO: Previously used vim-airline
  lualine-nvim
  lualine-lsp-progress
  scope-nvim
  bufferline-nvim
  nvim-navic

  # Termianl
  toggleterm-nvim

  # Git
  gitsigns-nvim # TODO: Previously used gitgutter instead.
  vim-fugitive

  # Which Key
  which-key-nvim

  # Dashboard
  dashboard-nvim
  dbsession-nvim

  # Tmux
  vim-tmux-navigator

  # Icon Picker
  icon-picker

  # Bookmarks
  vim-bookmarks
  telescope-vim-bookmarks-nvim

  # Line Indentation
  indent-blankline-nvim

  ########## End of global plugins

  # Nix
  vim-nix
  telescope-manix

  # Markdown
  markdown-preview-nvim
  vim-markdown
  vim-markdown-toc

  # Dotbox
  dotbox-nvim
]
