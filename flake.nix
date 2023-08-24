{
  description = "DxCx Neovim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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

      alias.packages.default = "neovim";
    };
}
