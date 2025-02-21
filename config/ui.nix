_: {
  ### TODO: Align to get existing indentation lines highlighted
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
    ## TODO: Replace with snacks like with highlighting on effective, or configure better.
    indent-blankline.enable = true;
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
