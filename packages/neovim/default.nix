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
    ./config/movement
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
    ./config/lsp/nix
    ./config/lsp/lua
    ./config/lsp/cpp
    ./config/lsp/cmake
    ./config/lsp/python

    # Also After LSP as it integrates to it.
    ./config/copilot
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
