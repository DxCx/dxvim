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
      };
    };

    # Visuals configuration
    visuals = {
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;
      highlight-undo.enable = true;
    };

    # UI configuration
    mini.icons.enable = true;
    ui = {
      borders.enable = true;
      colorizer.enable = true;
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
