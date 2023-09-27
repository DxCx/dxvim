{ vimUtils
, fetchFromGitHub
, ...
}:
let
  maximizer-nvim = vimUtils.buildVimPluginFrom2Nix {
    pname = "maximizer.nvim";
    version = "unstable-2023-11-24";
    src = fetchFromGitHub {
      owner = "0x00-ketsu";
      repo = "maximizer.nvim";
      rev = "a517c762168bc1f9881f67d257fe9565712776f0";
      sha256 = "0x52md39s449jngr5rjy33603dica1mylg75zvwvkf56k6ghjzvn";
    };
  };
in
[
  maximizer-nvim
]

