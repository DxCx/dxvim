_: let
  snacksConfig = {
    utility = {
      snacks-nvim = {
        enable = true;
        setupOpts = {
          indent = {
            # Adds: | at indent level
            enabled = true;
            priority = 1;
            char = "|";
            only_scope = false;
            only_current = false;
            hl = [
              "SnacksIndent1"
              "SnacksIndent2"
              "SnacksIndent3"
              "SnacksIndent4"
              "SnacksIndent5"
              "SnacksIndent6"
              "SnacksIndent7"
              "SnacksIndent8"
            ];
          };
        };
      };
    };
  };
in
  {
    ### TODO: Align to get selected line diff color

    # Statusline configuration
    statusline = {
      lualine = {
        enable = true;
        activeSection.b = [
          ''
            {
              "filetype",
              colored = true,
              icon_only = true,
              icon = { align = 'left' }
            }
          ''
          ''
            {
              "filename",
              symbols = {modified = ' ', readonly = ' '},
              separator = {right = ''},
              path = 2
            }
          ''
          ''
            {
              "",
              draw_empty = true,
              separator = { left = '', right = '' }
            }
          ''
        ];
      };
    };

    # Visuals configuration
    visuals = {
      nvim-web-devicons.enable = true;

      # Highlights the whole line the cursor is at.
      nvim-cursorline.enable = true;

      # Nicer loading progress on bottom right (Lsp for example)
      fidget-nvim.enable = true;

      # When pressing undo, will blink around the undo area.
      highlight-undo.enable = true;
    };

    # UI configuration
    mini.icons.enable = true;
    ui = {
      borders.enable = true;
      # Color codes rendering in place
      colorizer.enable = true;
      # places underscore under the variable name the cursor is at
      illuminate.enable = true;
      breadcrumbs = {
        enable = false;
        navbuddy.enable = false;
      };
      smartcolumn = {
        enable = true;
      };
      fastaction.enable = true;
    };
  }
  // snacksConfig
