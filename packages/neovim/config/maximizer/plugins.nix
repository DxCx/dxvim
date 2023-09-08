{ vimUtils
, fetchFromGitHub
, ...
}:
let
  maximizer-nvim = vimUtils.buildVimPluginFrom2Nix {
    pname = "maximizer.nvim";
    version = "unstable-2023-08-13";
    src = fetchFromGitHub {
      owner = "0x00-ketsu";
      repo = "maximizer.nvim";
      rev = "4779ea731b4babaae7a5a406d455bd7fd1971f85";
      sha256 = "0jiky21z0k7lqcq1hwri0rw1gamw1shm7cpg16y5aj1vwi8barrl";
    };
  };
in
[
  maximizer-nvim
]

