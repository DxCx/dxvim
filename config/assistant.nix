_: let
  # Define shared prompts for AI assistants
  # Context variables:
  # - {this}: auto-resolves to {position} for files, "this" + {selection} for non-files
  # - {position}: @filename:line:col
  # - {function}: function at cursor with location (requires treesitter-textobjects)
  # - {class}: class/struct at cursor with location (requires treesitter-textobjects)
  # - {file}: current file content
  # - {selection}: currently selected text
  # Visual mode prompts (selection-based)
  visualPrompts = [
    {
      title = "Explain code";
      prompt = "Please explain how {this} works, including its purpose, logic, and any important details.";
      keymap = "<leader>cce";
      mode = "v";
    }
    {
      title = "Review code";
      prompt = "Please review {this} for potential issues, bugs, performance problems, and suggest improvements.";
      keymap = "<leader>ccr";
      mode = "v";
    }
    {
      title = "Fix code";
      prompt = "Please analyze and fix any issues in {this}. Explain what was wrong and how you fixed it.";
      keymap = "<leader>ccf";
      mode = "v";
    }
    {
      title = "Optimize code";
      prompt = "Please optimize {this} for better performance, readability, and maintainability while preserving its functionality.";
      keymap = "<leader>cco";
      mode = "v";
    }
    {
      title = "Document code";
      prompt = "Please add comprehensive documentation to {this}, including docstrings, comments, and explanations of complex logic.";
      keymap = "<leader>ccD";
      mode = "v";
    }
    {
      title = "Generate tests";
      prompt = "Please generate comprehensive unit tests for {this}, covering edge cases and different scenarios.";
      keymap = "<leader>cct";
      mode = "v";
    }
    {
      title = "Simplify code";
      prompt = "Please simplify {this} while maintaining the same functionality. Make it more readable and easier to understand.";
      keymap = "<leader>ccs";
      mode = "v";
    }
    {
      title = "Refactor code";
      prompt = "Please refactor {this} to improve code structure, reduce complexity, and follow best practices.";
      keymap = "<leader>ccR";
      mode = "v";
    }
    {
      title = "Add error handling";
      prompt = "Please add proper error handling to {this}, including appropriate error messages and edge case handling.";
      keymap = "<leader>cch";
      mode = "v";
    }
    {
      title = "Debug code";
      prompt = "Please help me debug {this}. Identify potential bugs, logic errors, or issues that could cause problems.";
      keymap = "<leader>ccd";
      mode = "v";
    }
  ];

  # Normal mode prompts (file/function-level operations)
  normalPrompts = [
    {
      title = "Review file";
      prompt = "Can you review {file} for any issues, bugs, code smells, or improvements? Focus on code quality, performance, and maintainability.";
      keymap = "<leader>ccF";
      mode = "n";
    }
    {
      title = "Review function";
      prompt = "Please review {function} for potential issues, improvements, or best practice violations.";
      keymap = "<leader>ccw";
      mode = "n";
    }
    {
      title = "Review class";
      prompt = "Please review {class} for design issues, potential improvements, or best practice violations.";
      keymap = "<leader>ccc";
      mode = "n";
    }
    {
      title = "Document function";
      prompt = "Add comprehensive documentation to {function}, including parameter descriptions, return values, and usage examples.";
      keymap = "<leader>ccW";
      mode = "n";
    }
    {
      title = "Explain function";
      prompt = "Please explain what {function} does, how it works, its parameters, return values, and any important implementation details.";
      keymap = "<leader>ccE";
      mode = "n";
    }
    {
      title = "Fix quickfix";
      prompt = "Can you help me fix the issues in {quickfix}? Address each item systematically.";
      keymap = "<leader>ccq";
      mode = "n";
    }
  ];

  allPrompts = visualPrompts ++ normalPrompts;
in {
  # Assistant configuration
  assistant = {
    sidekick = {
      enable = true;
      cliProviders = ["cursor"];
      keymaps = {
        ask = "<leader>cc<CR>";
        toggle = "<leader>ccx";
        cli = "<leader>ccC";
        terminal = "<leader>ccT";
        suggest = "<leader>ccS";
        diagnostics = "<leader>ccdf";
        diagnosticsAll = "<leader>ccda";
        predefinedPrompts = allPrompts;
      };
      setupOpts = {
        # Disable NES (Next Edit Suggestions) - can be enabled if desired
        nes.enabled = false;

        # CLI configuration
        cli = {
          # Window layout: "float", "left", "right", "top", "bottom"
          win.layout = "right";

          # Window split size (when layout is not "float")
          win.split = {
            width = 80; # Right/left layout
            height = 20; # Top/bottom layout
          };

          # Use snacks picker (default) - alternatives: "telescope", "fzf-lua"
          picker = "snacks";

          # Watch for file changes made by CLI tools
          watch = true;
        };
      };
    };
  };
}
