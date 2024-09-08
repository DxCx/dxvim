{ vimUtils, fetchFromGitHub, ... }:
let
  hex-nvim = vimUtils.buildVimPlugin {
    pname = "hex-nvim";
    version = "unstable-2024-09-03";
    src = fetchFromGitHub {
      owner = "RaafatTurki";
      repo = "hex.nvim";
      rev = "d0f553dcd2c08d226026d769119b2eb6b09b8dfd";
      sha256 = "0dqv23i08ng4g7mm35g484p39i4b3vr6xnz3m7ij7n3d6bpfc8c3";
    };
  };
in
[ hex-nvim ]
