{ vimPlugins, vimUtils, fetchFromGitHub, ... }:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2024-02-28";
    src = fetchFromGitHub {
      owner = "CopilotC-Nvim";
      repo = "CopilotChat.nvim";
      rev = "b59c014df4fe09cdaa1ada170944bcfa1b00c82b";
      sha256 = "1i5rvlmxp4hlkyn95ry4xf9nyn1zil1wiyjfpgvqd7gq32s8arfj";
    };
  };

in with vimPlugins; [ copilot-chat-nvim copilot-lua copilot-cmp ]
