{
  vimPlugins,
  vimUtils,
  fetchFromGitHub,
  ...
}:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2024-06-01";
    src = fetchFromGitHub {
      owner = "CopilotC-Nvim";
      repo = "CopilotChat.nvim";
      rev = "82923efe22b604cf9c0cad0bb2a74aa9247755ab";
      sha256 = "0dh4hy62xjd8kjnmcflrsdj02b6wrakzppcawfj8r7w1nnbsmlbd";
    };
  };
in
with vimPlugins;
[
  copilot-chat-nvim
  copilot-lua
  copilot-cmp
]
