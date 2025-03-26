{
  vimPlugins,
  vimUtils,
  fetchFromGitHub,
  ...
}:
let
  dependencies = with vimPlugins; [
    plenary-nvim
  ];

  codecompanion-nvim = vimUtils.buildVimPlugin {
    pname = "codecompanion.nvim";
    version = "unstable-2025-03-27";
    src = fetchFromGitHub {
      owner = "olimorris";
      repo = "codecompanion.nvim";
      rev = "51fe5a782dbbd5cad8189420cb8d38fd7c245684";
      sha256 = "09vjvbf5rxmj2fax0ddcinbvx6mhjdy58fw9d1nf8ll7x8dj5j2s";
    };

    inherit dependencies;

    nvimSkipModule = [
      "codecompanion.providers.actions.mini_pick"
      "codecompanion.providers.actions.telescope"
      "minimal"
    ];
  };
in
dependencies
++ (with vimPlugins; [
  codecompanion-nvim
  copilot-lua
  copilot-cmp
])
