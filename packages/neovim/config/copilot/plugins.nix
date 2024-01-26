{ vimPlugins, vimUtils, fetchFromGitHub, ... }:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2024-01-19";
    src = fetchFromGitHub {
      owner = "gptlang";
      repo = "CopilotChat.nvim";
      rev = "2a6b2fcf5bb70b2aba9926b19afb88bc461165c0";
      sha256 = "0aybwk0w5npsnvg37sq59mqs7ynzj14xl7vm2bjd19agzwsswbfp";
    };
  };

in with vimPlugins; [ copilot-chat-nvim copilot-lua copilot-cmp ]
