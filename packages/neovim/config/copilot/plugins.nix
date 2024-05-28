{
  vimPlugins,
  vimUtils,
  fetchFromGitHub,
  ...
}:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2024-05-27";
    src = fetchFromGitHub {
      owner = "CopilotC-Nvim";
      repo = "CopilotChat.nvim";
      rev = "05775613be29d908fa8001e2ea82bf44beb618cb";
      sha256 = "0hc7gm09hmsda1r10yv618pr2h9jr0maaigk833jc92m4i4md29b";
    };
  };
in
with vimPlugins;
[
  copilot-chat-nvim
  copilot-lua
  copilot-cmp
]
