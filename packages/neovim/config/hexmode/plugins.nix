{ vimUtils, fetchFromGitHub, ... }:
let
  hex-nvim = vimUtils.buildVimPlugin {
    pname = "hex-nvim";
    version = "unstable-2024-03-03";
    src = fetchFromGitHub {
      owner = "RaafatTurki";
      repo = "hex.nvim";
      rev = "cbffd2ce4b8be089360e3c95d5909cd511d8840c";
      sha256 = "0dvhgdab3f2w7irh164qglj44h4hqba15yq223ckhka7l9r8nggq";
    };
  };
in [ hex-nvim ]
