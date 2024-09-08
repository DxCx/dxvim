{
  vimPlugins,
  vimUtils,
  fetchFromGitHub,
  ...
}:
let
  copilot-chat-nvim = vimUtils.buildVimPlugin {
    pname = "copilot-chat-nvim";
    version = "unstable-2024-09-06";
    src = fetchFromGitHub {
      owner = "CopilotC-Nvim";
      repo = "CopilotChat.nvim";
      rev = "9e7010bd33808e31d3f729b5e18a772d8e84f704";
      sha256 = "1srs6hrbqkil9s0ckcwgi5gj5mawcgah43yc0rr9lalx5m9my1md";
    };
  };
in
with vimPlugins;
[
  copilot-chat-nvim
  copilot-lua
  copilot-cmp
]
