{
  vimPlugins,
  vimUtils,
  fetchFromGitHub,
  ...
}:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2024-11-17";
    src = fetchFromGitHub {
      owner = "CopilotC-Nvim";
      repo = "CopilotChat.nvim";
      rev = "a1a16ee3a2c8cb88c4664af2e9fb7e014ef29a0c";
      sha256 = "1zzjxdcwmagm10haa4fsnj1hrqgqjnkxxx40pifa1gzcqilac91z";
    };
  };
in
with vimPlugins;
[
  copilot-chat-nvim
  copilot-lua
  copilot-cmp
]
