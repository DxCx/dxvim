{ vimPlugins
, fetchFromGitHub
, ...
}:
let
  # Latest version result in bugs =(
  # See https://github.com/phaazon/hop.nvim/issues/345
  hop-nvim-patched = vimPlugins.hop-nvim.overrideAttrs (old: {
    version = "reverted_2023-05-17";
    src = fetchFromGitHub {
      #owner = "phaazon";
      owner = "aznhe21";
      repo = "hop.nvim";
      rev = "2d3085e40154813b034bce1ad034f0d323c0c581";
      sha256 = "CTGyxMySz1amkz/87YQ7y1YfaWMNLK7UN9IACc4ahHk=";
    };
  });
in
with vimPlugins; [
  hop-nvim-patched
]
