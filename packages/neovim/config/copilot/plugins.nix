{ vimPlugins, vimUtils, fetchFromGitHub, ... }:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2024-02-18";
    src = fetchFromGitHub {
      owner = "CopilotC-Nvim";
      repo = "CopilotChat.nvim";
      rev = "e46fa23fe7c43a29c849fb9b6a1d565d2e0b83f1";
      sha256 = "1sh0j2gb6zxp81wfk3sqp2pjai02x29ymg237rsay2an2a9jq8rj";
    };
  };

in with vimPlugins; [ copilot-chat-nvim copilot-lua copilot-cmp ]
