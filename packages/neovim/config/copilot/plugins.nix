{
  vimPlugins,
  vimUtils,
  fetchFromGitHub,
  ...
}:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2024-07-23";
    src = fetchFromGitHub {
      owner = "CopilotC-Nvim";
      repo = "CopilotChat.nvim";
      rev = "f7861cb7d0ea46d57f67595876c8d2835eae29a2";
      sha256 = "1zfvxmll6mfiqmmbaqwnw177w7dgjl7l54f727gcjcf25rm4syl1";
    };
  };
in
with vimPlugins;
[
  copilot-chat-nvim
  copilot-lua
  copilot-cmp
]
