{lib, ...}: let
  # Define shared prompts for AI assistants
  sharedPrompts = [
    {
      title = "Explain code";
      prompt = "Please explain how this code works, including its purpose, logic, and any important details.";
      keymap = "<leader>cce";
      mode = "v";
    }
    {
      title = "Review code";
      prompt = "Please review this code for potential issues, bugs, performance problems, and suggest improvements.";
      keymap = "<leader>ccr";
      mode = "v";
    }
    {
      title = "Fix code";
      prompt = "Please analyze and fix any issues in this code. Explain what was wrong and how you fixed it.";
      keymap = "<leader>ccf";
      mode = "v";
    }
    {
      title = "Optimize code";
      prompt = "Please optimize this code for better performance, readability, and maintainability while preserving its functionality.";
      keymap = "<leader>cco";
      mode = "v";
    }
    {
      title = "Document code";
      prompt = "Please add comprehensive documentation to this code, including docstrings, comments, and explanations of complex logic.";
      keymap = "<leader>ccD";
      mode = "v";
    }
    {
      title = "Generate tests";
      prompt = "Please generate comprehensive unit tests for this code, covering edge cases and different scenarios.";
      keymap = "<leader>cct";
      mode = "v";
    }
  ];
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
      keymaps = {
        ask = "<leader>cc<CR>";
        gitCommit = "<leader>ccg";
        fixDiagnostic = "<leader>ccd";
        predefinedPrompts = sharedPrompts;
      };
      setupOpts = {
        model = "claude-3.7-sonnet-thought";
      };
    };
  };
}
