{
  description = "DxCx nvim config written using nvf";

  nixConfig = {
    extra-substituters = ["https://dxvim.cachix.org"];
    extra-trusted-public-keys = ["dxvim.cachix.org-1:bEdE17MPsQMGnnbsH8v3Xw/A3VneDtmwtDI8qb5h+/k="];
  };

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
    # Patched hop.nvim fork that fixes Neovim 0.10+ compatibility issues
    # See: https://github.com/phaazon/hop.nvim/issues/345
    hop-nvim-patched = {
      url = "github:aznhe21/hop.nvim";
      flake = false;
    };

    dxnixinfra = {
      url = "path:./dxnixinfra";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    nvf,
    sidekick-nvim,
    hop-nvim-patched,
    dxnixinfra,
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
      in
        {
          packages.default = customNeovim.neovim;
        }
        // dxnixinfra.lib.mkFlakeOutputs {
          src = ./.;
          inherit pkgs;
          extraChecks = {
            eval = pkgs.runCommand "eval-check" {} ''
              echo "Evaluating flake..." > $out
            '';

            build = pkgs.runCommand "build-check" {} ''
              ${customNeovim.neovim}/bin/nvim --version > $out
            '';

            plugins =
              pkgs.runCommand "plugin-test" {
                nativeBuildInputs = [customNeovim.neovim];
              } ''
                export HOME=$(mktemp -d)
                nvim --headless -c "echo 'OK'" -c "quit" 2>&1 | tee $out
              '';
          };
        }
    );
}
