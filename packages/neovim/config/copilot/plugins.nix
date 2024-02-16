{ vimPlugins, vimUtils, fetchFromGitHub, ... }:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2024-02-16";
    src = fetchFromGitHub {
      owner = "CopilotC-Nvim";
      repo = "CopilotChat.nvim";
      rev = "2ae6b8c9b8c9f226d0e019fa27e9b6a2263ff220";
      sha256 = "1wmnrd3rqw18a38ln3dp0yf9qfnbn263y358vb5nhnqd4f3v92k9";
    };
  };

in with vimPlugins; [ copilot-chat-nvim copilot-lua copilot-cmp ]
