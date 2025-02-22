{ lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.nvim.types) mkPluginSetupOption;
in
{
  options.vim.assistant.copilot-chat = {
    enable = mkEnableOption "CoPilot Chat AI assistant";
    setupOpts = mkPluginSetupOption "CopilotChat" { };
  };
}
