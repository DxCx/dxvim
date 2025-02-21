{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.nvim.binds) mkKeymap;
in {
  lazy.plugins = {
    "undotree" = {
      package = pkgs.vimPlugins.undotree;
      lazy = true;
      cmd = ["UndotreeToggle"];
    };
  };
  keymaps = [
    (mkKeymap "n" "<leader>tu" "<cmd>UndotreeToggle<CR>" {
      desc = "Toggle Undo Tree";
      silent = true;
    })
  ];
}
