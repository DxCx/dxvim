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
    version = "unstable-2025-03-23";
    src = fetchFromGitHub {
      owner = "olimorris";
      repo = "codecompanion.nvim";
      rev = "57bc5689a64a15b12251a8cd3c28dddd0d52c0cc";
      sha256 = "0i6zmcjx6jxgr02m9r78fpzka7smigydf5zmqjh12cg7jjvnyvgj";
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
