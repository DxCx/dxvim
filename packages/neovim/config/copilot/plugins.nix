{
  vimPlugins,
  vimUtils,
  fetchFromGitHub,
  ...
}:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2024-09-17";
    src = fetchFromGitHub {
      owner = "CopilotC-Nvim";
      repo = "CopilotChat.nvim";
      rev = "2352cd3e7e980cd73594be05f96b2dc4c0dd4a74";
      sha256 = "0pwrrm2p2bdxsd622smvx5q6ppsi590s5vyqzrs6yzkb7n2pnik6";
    };
  };
in
with vimPlugins;
[
  copilot-chat-nvim
  copilot-lua
  copilot-cmp
]
