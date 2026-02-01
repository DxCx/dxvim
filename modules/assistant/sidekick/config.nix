{
  pkgs,
  config,
  lib,
  sidekick-nvim,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.nvim.dag) entryAnywhere;
  inherit (lib.nvim.lua) toLuaObject;
  inherit (lib.nvim.binds) mkKeymap;
  inherit (lib.generators) mkLuaInline;

  cfg = config.vim.assistant.sidekick;
  keymapsCfg = cfg.keymaps;

  # Check if NES (Next Edit Suggestions) is disabled
  # Default to disabled (false) if not explicitly set
  nesDisabled = !(cfg.setupOpts.nes.enabled or false);

  # Build sidekick-nvim from flake input
  sidekickPackageBase = pkgs.vimUtils.buildVimPlugin {
    pname = "sidekick-nvim";
    version = "2025-01-08";
    src = sidekick-nvim;
    dependencies = [pkgs.vimPlugins.lazy-nvim pkgs.vimPlugins.snacks-nvim];
  };

  # Override to remove copilot-language-server dependency if NES is disabled
  sidekickPackage =
    if nesDisabled
    then
      sidekickPackageBase.overrideAttrs (old: {
        runtimeDeps = builtins.filter (
          dep:
            (builtins.parseDrvName dep.name).name != "copilot-language-server"
        ) (old.runtimeDeps or []);
      })
    else sidekickPackageBase;

  cliProviders = import ./cli-providers.nix {inherit pkgs lib;};

  # Sanitize title to create a legal command name
  # "Fix code & stuff" -> "FixCodeStuff"
  sanitizeTitle = title:
    lib.strings.concatMapStrings
    (char:
      if builtins.match "[a-zA-Z0-9]" char != null
      then char
      else "")
    (lib.strings.stringToCharacters title);

  # Get packages for enabled providers (filter out nulls)
  enabledProviderPackages = builtins.filter (pkg: pkg != null) (
    map (provider: cliProviders.providers.${provider}.package or null) cfg.cliProviders
  );

  # Filter tool definitions to only user-selected providers
  userTools = lib.filterAttrs (name: _: builtins.elem name cfg.cliProviders) cliProviders.toolDefinitions;

  # Convert user's predefined prompts to sidekick's prompt format
  userPrompts = builtins.listToAttrs (
    map (p: {
      name = lib.toLower (sanitizeTitle p.title); # "fixcode"
      value = p.prompt; # "Please fix this code"
    })
    keymapsCfg.predefinedPrompts
  );

  # Merge user prompts and tools into setupOpts
  # Note: For tools, we explicitly set them to REPLACE defaults, not merge
  setupOpts = let
    # Start with user's setupOpts (without cli)
    baseOpts = lib.filterAttrs (k: _: k != "cli") cfg.setupOpts;
    # Build cli config from scratch with only what we want
    cliConfig =
      (cfg.setupOpts.cli or {})
      // {
        prompts = ((cfg.setupOpts.cli or {}).prompts or {}) // userPrompts;
      }
      // (
        if cfg.cliProviders != []
        then {
          tools = userTools; # Explicit replacement
        }
        else {}
      );
  in
    baseOpts
    // {
      cli = cliConfig;
    };
in {
  config = mkIf cfg.enable (mkMerge [
    {
      vim = {
        extraPlugins = {
          sidekick = {
            package = sidekickPackage;
          };
        };

        # Install provider-specific CLI packages
        extraPackages = enabledProviderPackages;

        pluginRC.sidekick = entryAnywhere ''
          local setup_opts = ${toLuaObject setupOpts}
          require("sidekick").setup(setup_opts)

          -- Override: Replace tools entirely after setup (plugin merges with defaults)
          ${
            if cfg.cliProviders != []
            then ''
              local Config = require("sidekick.config")
              Config.cli.tools = setup_opts.cli.tools
            ''
            else ""
          }

          -- Generate wrapper for user input (Ask functionality)
          local sidekick_ask_user = function(options)
            -- Obtain input from the user and ask in chat
            vim.ui.input({ prompt = "Sidekick : " }, function(user_input)
              if not user_input or user_input == "" then return end
              -- Include location context: {position} for file buffers, {this} adds selection for non-files
              local msg = "{position} " .. user_input
              require("sidekick.cli").send({
                msg = msg,
                selection = options.range and options.range > 0,
                submit = true,
              })
            end)
          end
          vim.api.nvim_create_user_command('SidekickUserFreeText', sidekick_ask_user, { range = true })

          -- Commands for built-in diagnostic prompts
          -- Note: Built-in prompts already include location via {file} placeholder
          vim.api.nvim_create_user_command('SidekickDiagnostics', function()
            require("sidekick.cli").send({
              prompt = "diagnostics",
              submit = true,
            })
          end, {})

          vim.api.nvim_create_user_command('SidekickDiagnosticsAll', function()
            require("sidekick.cli").send({
              prompt = "diagnostics_all",
              submit = true,
            })
          end, {})

          -- Visual mode keymap for ask (captures selection while in visual mode)
          vim.keymap.set('v', '${keymapsCfg.ask}', function()
            -- Capture visual selection before vim.ui.input exits visual mode
            local mode = vim.fn.mode()
            vim.cmd('normal! ' .. mode)  -- Ensure marks are set
            local buf = vim.api.nvim_get_current_buf()
            local from = vim.api.nvim_buf_get_mark(buf, '<')
            local to = vim.api.nvim_buf_get_mark(buf, '>')

            vim.ui.input({ prompt = "Sidekick : " }, function(user_input)
              if not user_input or user_input == "" then return end

              -- Restore visual selection marks first
              vim.api.nvim_buf_set_mark(buf, '<', from[1], from[2], {})
              vim.api.nvim_buf_set_mark(buf, '>', to[1], to[2], {})

              -- Use schedule to ensure visual selection is restored before send()
              vim.schedule(function()
                vim.cmd('normal! gv')  -- Restore visual selection
                -- Include location context: {position} for file buffers
                local msg = "{position} " .. user_input
                require("sidekick.cli").send({
                  msg = msg,
                  selection = true,
                  submit = true,
                })
              end)
            end)
          end, { desc = "[Sidekick] Ask with context" })

          -- Generate commands for predefined prompts
          -- Note: Prompts should include {position} or {this} in their template for location
          ${lib.concatMapStringsSep "\n" (prompt: ''
              vim.api.nvim_create_user_command('SidekickPrompt${sanitizeTitle prompt.title}', function(opts)
                require("sidekick.cli").send({
                  prompt = "${lib.toLower (sanitizeTitle prompt.title)}",
                  selection = opts.range > 0,
                  submit = true,
                })
              end, { range = true })
            '')
            keymapsCfg.predefinedPrompts}

          -- Visual mode keymaps for predefined prompts (captures selection while in visual mode)
          ${lib.concatMapStringsSep "\n" (
              prompt:
                if prompt.mode == "v"
                then ''
                  vim.keymap.set('v', '${prompt.keymap}', function()
                    -- We're already in visual mode, so send immediately
                    -- Note: Prompts should include {position} or {this} in their template for location
                    require("sidekick.cli").send({
                      prompt = "${lib.toLower (sanitizeTitle prompt.title)}",
                      selection = true,
                      submit = true,
                    })
                  end, { desc = "[Sidekick] ${prompt.title}" })
                ''
                else ""
            )
            keymapsCfg.predefinedPrompts}
        '';

        # Sidekick key mappings - using new keymaps structure
        keymaps =
          # Special keymaps (visual mode is defined in pluginRC to capture selection properly)
          (lib.optionals (keymapsCfg.ask != null) [
            (mkKeymap "n" keymapsCfg.ask "<cmd>SidekickUserFreeText<CR>" {desc = "[Sidekick] Ask";})
          ])
          ++ (
            lib.optional (keymapsCfg.toggle != null)
            (mkKeymap "n" keymapsCfg.toggle "<cmd>SidekickToggle<CR>" {desc = "[Sidekick] Toggle Sidekick";})
          )
          ++ (
            lib.optional (keymapsCfg.cli != null)
            (mkKeymap "n" keymapsCfg.cli "<cmd>SidekickCli<CR>" {desc = "[Sidekick] Open CLI";})
          )
          ++ (
            lib.optional (keymapsCfg.terminal != null)
            (mkKeymap "n" keymapsCfg.terminal "<cmd>SidekickTerminal<CR>" {desc = "[Sidekick] Open Terminal";})
          )
          ++ (
            lib.optional (keymapsCfg.suggest != null)
            (mkKeymap "n" keymapsCfg.suggest "<cmd>SidekickSuggest<CR>" {desc = "[Sidekick] Next Edit Suggestion";})
          )
          ++ (
            lib.optional (keymapsCfg.diagnostics != null)
            (mkKeymap "n" keymapsCfg.diagnostics "<cmd>SidekickDiagnostics<CR>" {desc = "[Sidekick] Fix Diagnostics";})
          )
          ++ (
            lib.optional (keymapsCfg.diagnosticsAll != null)
            (mkKeymap "n" keymapsCfg.diagnosticsAll "<cmd>SidekickDiagnosticsAll<CR>" {desc = "[Sidekick] Fix All Diagnostics";})
          )
          # Predefined prompts (visual mode is defined in pluginRC to capture selection properly)
          ++ (
            lib.forEach
            (builtins.filter (p: p.mode != "v") keymapsCfg.predefinedPrompts)
            (prompt: (mkKeymap prompt.mode prompt.keymap "<cmd>SidekickPrompt${sanitizeTitle prompt.title}<CR>" {desc = "[Sidekick] ${prompt.title}";}))
          );
      };
    }
  ]);
}
