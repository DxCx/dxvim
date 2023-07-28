{ vimUtils
, fetchFromGitHub
, ...
}:
let
  maximizer-nvim = vimUtils.buildVimPluginFrom2Nix {
    pname = "maximizer.nvim";
    version = "unstable-2023-07-07";
    src = fetchFromGitHub {
      owner = "0x00-ketsu";
      repo = "maximizer.nvim";
      rev = "839b7cf3a1fa46c020fc874d5224274836d54691";
      sha256 = "0bp2fv1j6rcfzr5n8g1g1vw9mwn4xlnkhnsx13qla5hy62qkrldp";
    };
  };
in
[
  maximizer-nvim
]

