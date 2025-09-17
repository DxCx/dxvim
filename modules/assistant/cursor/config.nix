{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.nvim.types) mkGrammarOption;
  inherit (lib.nvim.dag) entryAnywhere;
  inherit (lib.nvim.lua) toLuaObject;

  treesitterDiffGrammer = mkGrammarOption pkgs "diff";

  # TODO: Obtain git, or from input?
  cursor-nvim-plugin-pkg = {};

  cfg = config.vim.assistant.cursor;
in {
  config = mkIf cfg.enable (mkMerge [
    {
      vim = {
        extraPlugins = with pkgs.vimPlugins; {
          cursor = {
            package = CopilotChat-nvim;
          };
        };

        extraPackages = with pkgs; [
          lynx
          cursor-cli
        ];

        pluginRC.cursor-nvim = entryAnywhere ''
          require("cursor-nvim").setup(${toLuaObject cfg.setupOpts})
        '';
      };
    }

    (mkIf config.vim.languages.enableTreesitter {
      vim.treesitter = {
        enable = true;
        grammars = [treesitterDiffGrammer.default];
      };
    })
  ]);
}
