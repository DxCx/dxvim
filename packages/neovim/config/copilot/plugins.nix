{ vimPlugins, vimUtils, fetchFromGitHub, ... }:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2024-02-23";
    src = fetchFromGitHub {
      owner = "CopilotC-Nvim";
      repo = "CopilotChat.nvim";
      rev = "93df47595d4f0b1cb011d9409fff09dee69f3a83";
      sha256 = "1xkcc97gdmm3d2q894q2k7dvcclbkyf1mq39k75gn2sn5gv75w3y";
    };
  };

in with vimPlugins; [ copilot-chat-nvim copilot-lua copilot-cmp ]
