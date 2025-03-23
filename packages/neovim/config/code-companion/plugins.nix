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
    version = "unstable-2025-03-22";
    src = fetchFromGitHub {
      owner = "olimorris";
      repo = "codecompanion.nvim";
      rev = "3b41af8ea3c858711cdc6f7589e2708d61f4948d";
      sha256 = "1r2ngg4smhg5bbxmd5kpf5r458zxx2rly7wpf2dnyvz53ahsq4jf";
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
