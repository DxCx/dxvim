{ vimPlugins, vimUtils, fetchFromGitHub, ... }:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2023-12-15";
    src = fetchFromGitHub {
      owner = "gptlang";
      repo = "CopilotChat.nvim";
      rev = "a45d44fee7e6d0bf36a95742a4073aa2ea2acfb6";
      sha256 = "1y5bjby695r3m06m62h4ndfmpkpi8c09smpaygsq632c7ah8xkb2";
    };
  };

in with vimPlugins; [ copilot-chat-nvim copilot-lua copilot-cmp ]
