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
          bold = true
        })
      '';
    };
  };
}
