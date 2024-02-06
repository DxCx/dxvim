{ vimPlugins, vimUtils, fetchFromGitHub, ... }:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2024-02-05";
    src = fetchFromGitHub {
      owner = "jellydn";
      repo = "CopilotChat.nvim";
      rev = "4c510acf31be9378730b75202ad4b3c2540259f1";
      sha256 = "10hw4ld448p8c2z5d0i9nhaq67z3281mc5m07q0ligng31jvy2j4";
    };
  };

in with vimPlugins; [ copilot-chat-nvim copilot-lua copilot-cmp ]
