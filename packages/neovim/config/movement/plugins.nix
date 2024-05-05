{ vimPlugins, fetchFromGitHub, ... }:
let
  # Latest version result in bugs =(
  # See https://github.com/phaazon/hop.nvim/issues/345
  hop-nvim-patched = vimPlugins.hop-nvim.overrideAttrs (old: {
    version = "unstable-2022-11-08";
    src = fetchFromGitHub {
      #owner = "phaazon";
      owner = "aznhe21";
      repo = "hop.nvim";
      rev = "a7454d16a762a2f50f235e68f35b30b0f20f3a35";
      sha256 = "0v4h0axz66ijwn4xms2j1rrsm7jc0mk30kngkgfbcnv3bf4xmr95";
    };
  });
in
with vimPlugins;
[ hop-nvim-patched ]
