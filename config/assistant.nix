{lib, ...}: let
  inherit (lib.nvim.binds) mkKeymap;
  inherit (lib.nvim.dag) entryAfter;
in {
  # Assistant configuration
  assistant = {
    # TODO: Not mature enough, but in the future look into replacing with
    # copilot-language-server
    #
    copilot = {
      enable = true;
      cmp.enable = true;
      setupOpts = {
        suggestion = {enabled = false;};
        copilot_model = "gpt-4o-copilot";
        panel = {enabled = false;};
        filetypes = {
          gitcommit = true;
          markdown = true;
          yaml = true;
          plantuml = true;
        };
      };
    };
    copilot-chat = {
      enable = true;
      setupOpts = {
        model = "claude-3.7-sonnet-thought";
      };
    };
  };

  luaConfigRC.copilot-chat = entryAfter ["pluginConfigs" "lazyConfigs"] ''
    -- Generate wrapper for user input
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

  keymaps = [
    (mkKeymap "n" "<leader>ccg" "<cmd>CopilotChatCommit<CR>" {desc = "[CopilotChat] Git Commit";})
    (mkKeymap "n" "<leader>ccd" "<cmd>CopilotChatFixDiagnostic<CR>" {desc = "[CopilotChat] Fix Diagnostic";})
    (mkKeymap "n" "<leader>cc<CR>" "<cmd>CopilotChatUserFreeText<CR>" {desc = "[CopilotChat] Ask";})

    (mkKeymap "v" "<leader>cc<CR>" "<cmd>CopilotChatUserFreeText<CR>" {desc = "[CopilotChat] Ask with context";})
    (mkKeymap "v" "<leader>cce" "<cmd>CopilotChatExplain<CR>" {desc = "[CopilotChat] Explain code";})
    (mkKeymap "v" "<leader>ccr" "<cmd>CopilotChatReview<CR>" {desc = "[CopilotChat] Review code";})
    (mkKeymap "v" "<leader>ccf" "<cmd>CopilotChatFix<CR>" {desc = "[CopilotChat] Fix code";})
    (mkKeymap "v" "<leader>cco" "<cmd>CopilotChatOptimize<CR>" {desc = "[CopilotChat] Optimize code";})
    (mkKeymap "v" "<leader>ccd" "<cmd>CopilotChatDocs<CR>" {desc = "[CopilotChat] Document code";})
    (mkKeymap "v" "<leader>cct" "<cmd>CopilotChatTests<CR>" {desc = "[CopilotChat] Generate tests";})
  ];
}
