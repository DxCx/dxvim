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
      prompt = "Analyze and explain {this} in detail. Cover: (1) What it does and its purpose, (2) How it works step-by-step, (3) Key algorithms or patterns used, (4) Input/output behavior, (5) Dependencies and side effects, (6) Any non-obvious implementation details. Be thorough and technical.";
      keymap = "<leader>cce";
      mode = "v";
    }
    {
      title = "Review code";
      prompt = "Perform a comprehensive code review of {this}. Check for: (1) Bugs and logic errors, (2) Performance bottlenecks and optimization opportunities, (3) Security vulnerabilities, (4) Code smells and anti-patterns, (5) Maintainability issues, (6) Missing error handling, (7) Best practice violations. Provide specific, actionable feedback with severity ratings.";
      keymap = "<leader>ccr";
      mode = "v";
    }
    {
      title = "Fix code";
      prompt = "Analyze {this} for bugs and issues, then provide a corrected version. For each fix: (1) Clearly explain what was wrong, (2) Show the corrected code, (3) Explain why the fix works, (4) Note any edge cases handled. Preserve existing functionality and coding style. Ensure the fix is production-ready.";
      keymap = "<leader>ccf";
      mode = "v";
    }
    {
      title = "Optimize code";
      prompt = "Optimize {this} for performance, readability, and maintainability. Consider: (1) Algorithmic improvements and complexity reduction, (2) Memory usage and allocation patterns, (3) Code clarity and simplification, (4) Removing redundant operations, (5) Better data structures or patterns. Preserve exact functionality. Explain each optimization with before/after comparison and performance impact.";
      keymap = "<leader>cco";
      mode = "v";
    }
    {
      title = "Document code";
      prompt = "Add professional documentation to {this}. Include: (1) Comprehensive docstrings/doc comments following language conventions, (2) Parameter descriptions with types and constraints, (3) Return value documentation, (4) Usage examples if applicable, (5) Inline comments for complex logic, (6) Notes about edge cases and exceptions. Use clear, concise, professional language.";
      keymap = "<leader>ccD";
      mode = "v";
    }
    {
      title = "Generate tests";
      prompt = "Write comprehensive unit tests for {this}. Include: (1) Happy path test cases, (2) Edge cases and boundary conditions, (3) Error cases and exception handling, (4) Input validation tests, (5) Mocking external dependencies if needed. Use appropriate testing framework conventions. Ensure high code coverage. Include test descriptions explaining what each test validates.";
      keymap = "<leader>cct";
      mode = "v";
    }
    {
      title = "Simplify code";
      prompt = "Simplify {this} while maintaining identical functionality. Focus on: (1) Reducing complexity and nesting, (2) Extracting magic numbers/strings to constants, (3) Using clearer variable/function names, (4) Breaking down complex expressions, (5) Removing unnecessary abstractions. Explain what was simplified and why. Ensure the simplified version is easier to read and understand.";
      keymap = "<leader>ccs";
      mode = "v";
    }
    {
      title = "Refactor code";
      prompt = "Refactor {this} following SOLID principles and best practices. Consider: (1) Single Responsibility Principle, (2) Reducing coupling and increasing cohesion, (3) Extracting methods/functions where appropriate, (4) Improving naming and structure, (5) Eliminating code duplication (DRY), (6) Better error handling patterns. Maintain backward compatibility. Explain the refactoring rationale and benefits.";
      keymap = "<leader>ccR";
      mode = "v";
    }
    {
      title = "Add error handling";
      prompt = "Add robust error handling to {this}. Include: (1) Input validation and preconditions, (2) Try-catch/error handling blocks where appropriate, (3) Meaningful error messages with context, (4) Proper error propagation or recovery strategies, (5) Edge case handling, (6) Resource cleanup (finally blocks, defer statements, etc.). Use appropriate error types. Ensure errors are actionable and help with debugging.";
      keymap = "<leader>cch";
      mode = "v";
    }
    {
      title = "Debug code";
      prompt = "Debug {this} systematically. Identify: (1) Potential bugs and logic errors, (2) Off-by-one errors or boundary issues, (3) Race conditions or concurrency problems, (4) Memory leaks or resource issues, (5) Incorrect assumptions or edge cases not handled, (6) Type mismatches or implicit conversions. For each issue found, explain the problem, why it occurs, and suggest a fix. Provide debugging strategies if needed.";
      keymap = "<leader>ccd";
      mode = "v";
    }
    {
      title = "Convert to async";
      prompt = "Convert {this} to use asynchronous patterns where appropriate. Consider: (1) Identifying blocking operations that can be async, (2) Converting to async/await or promise-based patterns, (3) Handling async errors properly, (4) Maintaining backward compatibility if needed, (5) Performance implications. Preserve functionality. Explain the conversion approach and any trade-offs.";
      keymap = "<leader>cca";
      mode = "v";
    }
    {
      title = "Add type safety";
      prompt = "Add type annotations and improve type safety for {this}. Include: (1) Explicit type annotations for parameters and return values, (2) Type guards and type narrowing where needed, (3) Generic types if applicable, (4) Union types for multiple valid types, (5) Proper null/undefined handling. Use strict typing. Explain the type choices and how they improve safety.";
      keymap = "<leader>ccy";
      mode = "v";
    }
  ];

  # Normal mode prompts (file/function-level operations)
  normalPrompts = [
    {
      title = "Review file";
      prompt = "Perform a comprehensive code review of {file}. Analyze: (1) Overall architecture and design patterns, (2) Code organization and structure, (3) Potential bugs and issues throughout, (4) Performance optimization opportunities, (5) Security concerns, (6) Code smells and technical debt, (7) Missing tests or documentation, (8) Consistency with project conventions. Provide prioritized recommendations with specific line references.";
      keymap = "<leader>ccF";
      mode = "n";
    }
    {
      title = "Review function";
      prompt = "Review {function} for code quality. Check: (1) Function signature and parameter design, (2) Single Responsibility Principle adherence, (3) Complexity and cyclomatic complexity, (4) Error handling completeness, (5) Performance considerations, (6) Testability, (7) Documentation quality, (8) Naming clarity. Provide specific, actionable feedback with suggestions for improvement.";
      keymap = "<leader>ccw";
      mode = "n";
    }
    {
      title = "Review class";
      prompt = "Review {class} design and implementation. Evaluate: (1) Class cohesion and responsibilities, (2) Encapsulation and data hiding, (3) Inheritance/composition design, (4) SOLID principles adherence, (5) Public API design, (6) Method complexity and organization, (7) Dependency management, (8) Testability. Provide architectural feedback and refactoring suggestions if needed.";
      keymap = "<leader>ccc";
      mode = "n";
    }
    {
      title = "Document function";
      prompt = "Write comprehensive documentation for {function}. Include: (1) Function purpose and overview, (2) Detailed parameter documentation with types, constraints, and examples, (3) Return value documentation with possible values, (4) Thrown exceptions or error conditions, (5) Usage examples with different scenarios, (6) Performance characteristics if relevant, (7) Side effects or state mutations. Follow language-specific documentation conventions (JSDoc, docstrings, etc.).";
      keymap = "<leader>ccW";
      mode = "n";
    }
    {
      title = "Explain function";
      prompt = "Provide a detailed explanation of {function}. Cover: (1) What the function does and its purpose, (2) How it works algorithmically, (3) Parameter details and their roles, (4) Return value and its meaning, (5) Edge cases and special behaviors, (6) Dependencies and side effects, (7) Time/space complexity if applicable, (8) Relationship to other functions/modules. Be thorough and technical.";
      keymap = "<leader>ccE";
      mode = "n";
    }
    {
      title = "Fix quickfix";
      prompt = "Systematically fix all issues in {quickfix}. For each item: (1) Understand the root cause, (2) Implement the fix, (3) Verify the fix resolves the issue, (4) Ensure no regressions. Group related fixes together. Maintain code style consistency. If a fix is non-trivial, explain the approach. Work through items in order of severity if possible.";
      keymap = "<leader>ccq";
      mode = "n";
    }
    {
      title = "Analyze complexity";
      prompt = "Analyze the time and space complexity of {function}. Determine: (1) Time complexity (Big O notation) for best, average, and worst cases, (2) Space complexity including auxiliary space, (3) Bottlenecks and hot paths, (4) Scalability concerns, (5) Optimization opportunities. Provide detailed analysis with reasoning. Suggest improvements if complexity can be reduced.";
      keymap = "<leader>ccA";
      mode = "n";
    }
    {
      title = "Suggest improvements";
      prompt = "Analyze {function} and suggest improvements. Consider: (1) Modern language features that could simplify the code, (2) Better algorithms or data structures, (3) Performance optimizations, (4) Readability improvements, (5) Maintainability enhancements, (6) Security hardening, (7) Better error handling, (8) Testing improvements. Prioritize suggestions by impact. Explain the benefits of each suggestion.";
      keymap = "<leader>cci";
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
