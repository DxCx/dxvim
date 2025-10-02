{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.nvim.types) mkPluginSetupOption;
  inherit (lib.types) str listOf submodule nullOr enum;

  cliProviders = import ./cli-providers.nix {inherit pkgs lib;};
in {
  options.vim.assistant.sidekick = {
    enable = mkEnableOption "Sidekick AI assistant with CLI integration";

    cliProviders = mkOption {
      type = listOf (enum cliProviders.availableProviders);
      default = [];
      description = ''
        List of AI CLI providers to enable.
        Automatically installs the required packages when available in nixpkgs.
        Available providers: ${lib.concatStringsSep ", " cliProviders.availableProviders}
      '';
      example = ["cursor" "claude" "copilot"];
    };

    keymaps = mkOption {
      type = submodule {
        options = {
          ask = mkOption {
            type = nullOr str;
            default = "<leader>sk<CR>";
            description = "Keymap for asking freeform questions";
          };
          toggle = mkOption {
            type = nullOr str;
            default = "<leader>sk";
            description = "Keymap for toggling sidekick";
          };
          cli = mkOption {
            type = nullOr str;
            default = "<leader>skc";
            description = "Keymap for opening CLI";
          };
          terminal = mkOption {
            type = nullOr str;
            default = "<leader>skt";
            description = "Keymap for opening terminal";
          };
          suggest = mkOption {
            type = nullOr str;
            default = "<leader>sks";
            description = "Keymap for next edit suggestion";
          };
          diagnostics = mkOption {
            type = nullOr str;
            default = null;
            description = "Keymap for fixing diagnostics in current file (built-in prompt)";
          };
          diagnosticsAll = mkOption {
            type = nullOr str;
            default = null;
            description = "Keymap for fixing all diagnostics in project (built-in prompt)";
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
                  description = "Full keymap binding (e.g., <leader>skf)";
                  example = "<leader>skf";
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
                keymap = "<leader>skf";
                mode = "v";
              }
            ];
          };
        };
      };
      default = {};
      description = "Keymap configuration for sidekick";
    };

    setupOpts = mkPluginSetupOption "sidekick" {};
  };
}
