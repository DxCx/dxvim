{ vimPlugins, vimUtils, fetchFromGitHub, ... }:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2024-02-03";
    src = fetchFromGitHub {
      owner = "jellydn";
      repo = "CopilotChat.nvim";
      rev = "6a17928cc142a1f15013ac4bbab297b05d94d6c3";
      sha256 = "10bwpnagn5x38ynim1qzv41xpvkij4hx2xjhlpfxx1gdan002rpg";
    };
  };

in with vimPlugins; [ copilot-chat-nvim copilot-lua copilot-cmp ]
