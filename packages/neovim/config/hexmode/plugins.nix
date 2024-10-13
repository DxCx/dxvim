{ vimUtils, fetchFromGitHub, ... }:
let
  hex-nvim = vimUtils.buildVimPlugin {
    pname = "hex-nvim";
    version = "unstable-2024-10-09";
    src = fetchFromGitHub {
      owner = "RaafatTurki";
      repo = "hex.nvim";
      rev = "fcff75fcf43b5a6c5b471eed65b3a06c412d6020";
      sha256 = "1wh8dnx9a8pjq53v7crhxczv0bzvv2gdj2ra7n2w66cql75piw4v";
    };
  };
in
[ hex-nvim ]
