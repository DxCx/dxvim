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
  ];

  # Define description for the Nix Package
  description = "DxCx's Neovim";

  # Define exported target for Nix Package
  mainProgram = "nvim";
}
