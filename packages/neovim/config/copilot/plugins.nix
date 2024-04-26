{ vimPlugins, vimUtils, fetchFromGitHub, ... }:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2024-04-25";
    src = fetchFromGitHub {
      owner = "CopilotC-Nvim";
      repo = "CopilotChat.nvim";
      rev = "6fe9ad2cc967ad8a2621fa2beb3c74eee2f4bc65";
      sha256 = "1v8qxs77dxlm4gwrcrqad4dbnj7msn6jd4591nvw0d1vq4xy9ffd";
    };
  };

in with vimPlugins; [ copilot-chat-nvim copilot-lua copilot-cmp ]
