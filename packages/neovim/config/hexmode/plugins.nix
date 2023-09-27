{ vimUtils
, fetchFromGitHub
, ...
}:
let
  hex-nvim = vimUtils.buildVimPluginFrom2Nix {
    pname = "hex-nvim";
    version = "unstable-2023-09-09";
    src = fetchFromGitHub {
      owner = "RaafatTurki";
      repo = "hex.nvim";
      rev = "dc51e5d67fc994380b7c7a518b6b625cde4b3062";
      sha256 = "13j27zc18chlgv9w7ml7j3lxbl7lkcqvvwys05hw0dbhik13bcyh";
    };
  };
in
[
  hex-nvim
]
