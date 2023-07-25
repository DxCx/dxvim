{ vimUtils
, fetchFromGitHub
, ...
}:
let
  hex-nvim = vimUtils.buildVimPluginFrom2Nix {
    pname = "hex-nvim";
    version = "unstable-2023-08-09";
    src = fetchFromGitHub {
      owner = "RaafatTurki";
      repo = "hex.nvim";
      rev = "63411ffe59fb8ecc3611367731cf13effc4d706f";
      sha256 = "0nffd7yqp1f3yq10k8xdk0w4k7lx6yvxaih99aql4a5s417zlqsd";
    };
  };
in
[
  hex-nvim
]
