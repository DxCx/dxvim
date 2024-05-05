{ pkgs, nodePackages, ... }:

with pkgs;
[
  # Formatters (HTML, CSS)
  nodePackages.prettier

  # LS (HTML, CSS)
  nodePackages.vscode-langservers-extracted

  # HTML
  html-tidy

  # CSS
  nodePackages.stylelint
]
