{ pkgs, ... }:
{
  # Disable nvf theme configuration, override below
  theme = {
    enable = false;
  };

  extraPlugins = {
    horizon-nvim = {
      package = pkgs.vimUtils.buildVimPlugin {
        pname = "horizon-nvim";
        version = "unstable-2024-01-23";
        src = builtins.fetchGit {
          url = "https://github.com/akinsho/horizon.nvim.git";
          ref = "master";
          rev = "b4d7b1e7c3aa77aea31b9ced8960e49fd8682c47";
        };
      };
      setup = ''
        require('horizon').setup {}
        vim.cmd.colorscheme("horizon")
      '';
    };
  };

  statusline = {
    lualine = {
      theme = "horizon";
    };
  };
}
