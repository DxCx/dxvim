{ vimPlugins, vimUtils, fetchFromGitHub, ... }:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2024-01-20";
    src = fetchFromGitHub {
      owner = "jellydn";
      repo = "CopilotChat.nvim";
      rev = "6a34829fde1970c0b99a7bdf2dc6b35ad0d4dc91";
      sha256 = "18rrch7ylm6z3xb3jjr2ihpci6lpm33r151z0z8zdpbic0ainm59";
    };
  };

in with vimPlugins; [ copilot-chat-nvim copilot-lua copilot-cmp ]
