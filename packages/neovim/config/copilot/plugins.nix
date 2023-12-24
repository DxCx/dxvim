{ vimPlugins, vimUtils, fetchFromGitHub, ... }:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2023-12-22";
    src = fetchFromGitHub {
      owner = "gptlang";
      repo = "CopilotChat.nvim";
      rev = "cb9d633db0027f924d54f6d635335381ee311392";
      sha256 = "1mxc294rj3v4nrjqchixdrhsa12bqsxmvkjc5yq6yp1k20xhyj3r";
    };
  };

in with vimPlugins; [ copilot-chat-nvim copilot-lua copilot-cmp ]
