{lib, ...}: let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.nvim.types) mkPluginSetupOption;
  inherit (lib.types) bool;
in {
  options.vim.assistant.copilot-chat = {
    enable = mkEnableOption "CoPilot Chat AI assistant";
    enableRipGrep = mkOption {
      type = bool;
      default = true;
      description = "Install RipGrep utility for faster searches";
    };
    setupOpts = mkPluginSetupOption "CopilotChat" {};
  };
}
