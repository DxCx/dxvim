{
  description = "DxCx Neovim configuration";

  inputs = {
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.follows = "neovim-nightly/nixpkgs";

    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    snowfall-lib = {
      url = "github:snowfallorg/lib/dev";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils-plus.follows = "utils";
      };
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;

      package-namespace = "dxvim";

      src = ./.;

      overlays = [ inputs.neovim-nightly.overlay ];

      alias.packages.default = "neovim";
    };
}
