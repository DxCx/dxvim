{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.nvim.binds) mkKeymap;
in {
  extraPackages = with pkgs; [
    unixtools.xxd
  ];
  lazy.plugins = {
    "hex.nvim" = {
      package = pkgs.vimPlugins.hex-nvim;
      lazy = true;
      setupModule = "hex";
      setupOpts = {};
      cmd = ["HexToggle"];
    };
  };
  keymaps = [
    (mkKeymap "n" "<leader>th" "<cmd>HexToggle<CR>" {
      desc = "Toggle Hex View";
      silent = true;
    })
  ];
}
