{lib, ...}: let
  inherit (lib.options) mkEnableOption;
  inherit (lib.nvim.types) mkPluginSetupOption;
in {
  options.vim.assistant.cursor = {
    enable = mkEnableOption "Cursor CLI AI assistant";
    setupOpts = mkPluginSetupOption "cursor-nvim-plugin" {};
  };
}
