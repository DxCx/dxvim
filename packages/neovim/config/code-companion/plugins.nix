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
    version = "unstable-2025-03-13";
    src = fetchFromGitHub {
      owner = "olimorris";
      repo = "codecompanion.nvim";
      rev = "4f56b047f03bf5edc0d71bf0ca694243a49b912f";
      sha256 = "1mrb8qxd6mz5dlly9bh30pcd599gfy173f6pd4p8lszs3xhp598k";
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
