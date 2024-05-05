{ vimPlugins, fetchFromGitHub, ... }:
let
  origianl-nvim-treesitter = vimPlugins.nvim-treesitter;

  updated-treesitter = origianl-nvim-treesitter;
  # updated-treesitter = origianl-nvim-treesitter.overrideAttrs (old: {
  #   version = "2023-08-07";
  #   src = fetchFromGitHub {
  #     owner = "nvim-treesitter";
  #     repo = "nvim-treesitter";
  #     rev = "2051c8603d572c5a0b23225549fd7d735adf115f";
  #     sha256 = "1mkgc69rgvhwnbbd2hihksrxwfjp4vcn0yglcz4v5xqaa96pf71c";
  #   };
  # });

  res = updated-treesitter.withAllGrammars;
in
res
