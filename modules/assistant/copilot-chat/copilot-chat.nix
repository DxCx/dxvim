# NOTE: This module is currently unused but kept available for future use.
# To enable, set `vim.assistant.copilot-chat.enable = true` in your config.
# Provides an alternative to sidekick for GitHub Copilot Chat integration.
{lib, ...}: let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.nvim.types) mkPluginSetupOption;
  inherit (lib.types) bool listOf submodule str nullOr;
in {
  options.vim.assistant.copilot-chat = {
    enable = mkEnableOption "CoPilot Chat AI assistant";
    enableRipGrep = mkOption {
      type = bool;
      default = true;
      description = "Install RipGrep utility for faster searches";
    };
    keymaps = mkOption {
      type = submodule {
        options = {
          ask = mkOption {
            type = nullOr str;
            default = "<leader>cc<CR>";
            description = "Keymap for asking freeform questions";
          };
          gitCommit = mkOption {
            type = nullOr str;
            default = "<leader>ccg";
            description = "Keymap for generating git commit messages";
          };
          fixDiagnostic = mkOption {
            type = nullOr str;
            default = "<leader>ccd";
            description = "Keymap for fixing diagnostics";
          };
          predefinedPrompts = mkOption {
            type = listOf (submodule {
              options = {
                title = mkOption {
                  type = str;
                  description = "Title for the prompt (shown in WhichKey)";
                  example = "Fix code";
                };
                prompt = mkOption {
                  type = str;
                  description = "The actual prompt text to send to the AI";
                  example = "Please fix this code snippet";
                };
                keymap = mkOption {
                  type = str;
                  description = "Full keymap binding (e.g., <leader>ccf)";
                  example = "<leader>ccf";
                };
                mode = mkOption {
                  type = str;
                  description = "Vim mode for the keymap (n, v, i, etc.)";
                  example = "v";
                  default = "v";
                };
              };
            });
            default = [];
            description = "List of predefined prompts with keymap bindings";
            example = [
              {
                title = "Fix code";
                prompt = "Please fix this code snippet";
                keymap = "<leader>ccf";
                mode = "v";
              }
            ];
          };
        };
      };
      default = {};
      description = "Keymap configuration for copilot-chat";
    };
    setupOpts = mkPluginSetupOption "CopilotChat" {};
  };
}
