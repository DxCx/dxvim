{
  description = "DxCx nvim config written using nvf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    nvf,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfreePredicate = pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [
              "cursor-cli"
              "gh-copilot"
              "copilot-language-server" # Required by sidekick.nvim for NES
              # Add other approved unfree packages here
            ];
        };

        # Create custom nvim package
        customNeovim = nvf.lib.neovimConfiguration {
          modules = [
            ./modules
            ./config
          ];
          inherit pkgs;
        };
      in {
        packages.default = customNeovim.neovim;
      }
    );
}
