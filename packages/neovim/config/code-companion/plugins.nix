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
    version = "unstable-2025-03-20";
    src = fetchFromGitHub {
      owner = "olimorris";
      repo = "codecompanion.nvim";
      rev = "a344661b8c1eaae9a56db5c36e7f5d2101b69128";
      sha256 = "1gyakqjxxfxd27wc570c3qprinsgb7c9faq5fwx94nzybyi63ik3";
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
