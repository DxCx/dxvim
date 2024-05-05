{ pkgs, nodePackages, ... }:

with pkgs;
[
  # Formatters (typescript)
  nodePackages.prettier

  # Typescript
  nodePackages.typescript-language-server
  nodePackages.typescript

  # Javascript
  flow
  nodePackages.eslint
]
