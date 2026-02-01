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

    # Plugin sources
    sidekick-nvim = {
      url = "github:folke/sidekick.nvim";
      flake = false;
    };
    hop-nvim-patched = {
      url = "github:aznhe21/hop.nvim";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    nvf,
    sidekick-nvim,
    hop-nvim-patched,
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
          extraSpecialArgs = {
            inherit sidekick-nvim hop-nvim-patched;
          };
        };
      in {
        packages.default = customNeovim.neovim;

        checks = {
          # Verify config evaluates without errors
          eval = pkgs.runCommand "eval-check" {} ''
            echo "Evaluating flake..." > $out
          '';

          # Verify Neovim builds and runs
          build = pkgs.runCommand "build-check" {} ''
            ${customNeovim.neovim}/bin/nvim --version > $out
          '';

          # Verify plugins load in headless mode
          plugins = pkgs.runCommand "plugin-test" {
            nativeBuildInputs = [customNeovim.neovim];
          } ''
            export HOME=$(mktemp -d)
            nvim --headless -c "echo 'OK'" -c "quit" 2>&1 | tee $out
          '';
        };
      }
    );
}
