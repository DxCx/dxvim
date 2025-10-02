{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.nvim.types) mkGrammarOption;
  inherit (lib.nvim.dag) entryAnywhere;
  inherit (lib.nvim.lua) toLuaObject;
  inherit (lib.nvim.binds) mkKeymap;

  treesitterDiffGrammer = mkGrammarOption pkgs "diff";

  cfg = config.vim.assistant.copilot-chat;
  keymapsCfg = cfg.keymaps;
in {
  config = mkIf cfg.enable (mkMerge [
    {
      vim = {
        extraPlugins = with pkgs.vimPlugins; {
          copilot-chat = {
            package = CopilotChat-nvim;
          };
        };

        extraPackages = with pkgs; [
          lynx
        ];

        luaPackages = [
          "tiktoken_core"
        ];

        pluginRC.copilot-chat = entryAnywhere ''
          require("CopilotChat").setup(${toLuaObject cfg.setupOpts})

          -- Generate wrapper for user input (Ask functionality)
          local chat_ask_user = function(options)
            -- Select selection method based on using range or not.
            local selection = require("CopilotChat.select").buffer
            if options.range then
              selection = require("CopilotChat.select").visual
            end

            -- Obtain input from the user and ask in chat
            vim.ui.input({ prompt = "Copilot Chat : " }, function(user_input)
              require("CopilotChat").ask(user_input, {
                selection = selection,
              })
            end)
          end
          vim.api.nvim_create_user_command('CopilotChatUserFreeText', chat_ask_user, { range = true })
        '';

        # Copilot Chat key mappings - using new keymaps structure
        keymaps =
          # Special keymaps
          (lib.optionals (keymapsCfg.ask != null) [
            (mkKeymap "n" keymapsCfg.ask "<cmd>CopilotChatUserFreeText<CR>" {desc = "[CopilotChat] Ask";})
            (mkKeymap "v" keymapsCfg.ask "<cmd>CopilotChatUserFreeText<CR>" {desc = "[CopilotChat] Ask with context";})
          ])
          ++ (
            lib.optional (keymapsCfg.gitCommit != null)
            (mkKeymap "n" keymapsCfg.gitCommit "<cmd>CopilotChatCommit<CR>" {desc = "[CopilotChat] Git Commit";})
          )
          ++ (
            lib.optional (keymapsCfg.fixDiagnostic != null)
            (mkKeymap "n" keymapsCfg.fixDiagnostic "<cmd>CopilotChatFixDiagnostic<CR>" {desc = "[CopilotChat] Fix Diagnostic";})
          )
          # Predefined prompts
          ++ (lib.forEach keymapsCfg.predefinedPrompts (
            prompt: (mkKeymap prompt.mode prompt.keymap "<cmd>CopilotChatAsk '${prompt.prompt}'<CR>" {desc = "[CopilotChat] ${prompt.title}";})
          ));
      };
    }

    (mkIf cfg.enableRipGrep {
      vim.extraPackages = with pkgs; [
        ripgrep
      ];
    })

    (mkIf config.vim.languages.enableTreesitter {
      vim.treesitter = {
        enable = true;
        grammars = [treesitterDiffGrammer.default];
      };
    })
  ]);
}
