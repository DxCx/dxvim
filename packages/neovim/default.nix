{ callPackage, ... }:
let
  wrapped-neovim = callPackage ./wrapped-neovim { };
in
wrapped-neovim.mkWrappedNeovim {
  # Define which layouts to import
  layouts = [
    {
      # Expanded just to make sure this always works.
      dir = ./config/base;
      options = { };
    }
    ./config/which-key
    ./config/direnv
    ./config/maximizer
    ./config/filetree
    ./config/undotree
    ./config/theme
    ./config/dashboard
    ./config/hexmode
    ./config/editing
    ./config/git

    # Lsp must come before any other lsp layout
    ./config/lsp
    ./config/lsp/common # markdown, yaml, toml
    ./config/lsp/web # html, css
    ./config/lsp/nix
    ./config/lsp/lua
    ./config/lsp/cpp
    ./config/lsp/cmake
    ./config/lsp/python
    ./config/lsp/typescript # Also includes javascript
    ./config/lsp/graphql
    ./config/lsp/docker
    ./config/lsp/diagram
    ./config/lsp/rust

    # Assistant
    # Copilot/Chat plugins
    ./config/copilot
    # Alternative CodeCompanion - Not good enough yet..
    # ./config/code-companion

    # Also After LSP as it integrates to it.
    ./config/telescope
    ./config/navic

    # After navic as it integrates to it.
    ./config/statusline
  ];

  # Define description for the Nix Package
  description = "DxCx's Neovim";

  # Define exported target for Nix Package
  mainProgram = "nvim";
}
