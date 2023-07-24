{ pkgs, ... }:

with pkgs; [
  # Grammar
  tree-sitter

  # Formatters
  nodePackages.prettier

  # Utility
  ripgrep
  fzf
  unixtools.xxd
]
