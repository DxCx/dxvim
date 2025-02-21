{pkgs, ...}: {
  # Disable nvf theme configuration, override below
  theme = {
    enable = false;
  };

  lazy.plugins = {
    "nightfox.nvim" = {
      package = pkgs.vimPlugins.nightfox-nvim;
      setupModule = "nightfox";
      setupOpts = {
      };
      lazy = false;
      after = ''
        vim.cmd.colorscheme("nightfox")

        vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
          -- fg = "#39506D",  -- Adjust color to be more visible than default
          bold = true
        })
      '';
    };
  };
}
