{ vimPlugins, vimUtils, fetchFromGitHub, ... }:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2024-03-02";
    src = fetchFromGitHub {
      owner = "CopilotC-Nvim";
      repo = "CopilotChat.nvim";
      rev = "8434e3be4d5019fdc4ffc59a27650e39bdd1c2dc";
      sha256 = "1q6r1yyzph4pqya6dw2cgxzmxx5cqb9aja4q0qy6l7r4livg8kkw";
    };
  };

in with vimPlugins; [ copilot-chat-nvim copilot-lua copilot-cmp ]
