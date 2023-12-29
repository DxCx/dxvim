{ vimPlugins, ... }:
let
  # { vimPlugins, vimUtils, fetchFromGitHub, ... }:
  #copilot-chat-nvim = vimUtils.buildVimPlugin {
  #  pname = "copilot-chat-nvim";
  #  version = "unstable-2023-12-27";
  #  src = fetchFromGitHub {
  #    owner = "gptlang";
  #    repo = "CopilotChat.nvim";
  #    rev = "35a63ccd7a1992b8980a8a249fd2b8e1ec91573a";
  #    sha256 = "08va027mr29ffdpwncli7pnv9jqybpq1acdy9i7vrivdslc9x2ja";
  #  };
  #};

  packages = with vimPlugins; [
    #copilot-chat-nvim
    copilot-lua
    copilot-cmp
  ];
in packages
