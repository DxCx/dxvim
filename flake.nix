{
  description = "DxCx nvim config written using nvf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        flake-utils.follows = "flake-utils";
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
        pkgs = nixpkgs.legacyPackages.${system};

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
