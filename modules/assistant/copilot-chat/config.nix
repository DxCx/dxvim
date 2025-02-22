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

  cfg = config.vim.assistant.copilot-chat;
in {
  config = mkIf cfg.enable (mkMerge [
    {
      vim = {
        extraPlugins = with pkgs.vimPlugins; {
          copilot-chat = {
            package = CopilotChat-nvim;
          };
        };

        extraPackages = with pkgs; [
          lynx
        ];

        luaPackages = [
          "tiktoken_core"
        ];

        pluginRC.copilot-chat = entryAnywhere ''
          require("CopilotChat").setup(${toLuaObject cfg.setupOpts})
        '';
      };
    }

    (mkIf cfg.enableRipGrep {
      vim.extraPackages = with pkgs; [
        ripgrep
      ];
    })

    (mkIf config.vim.languages.enableTreesitter {
      vim.treesitter = {
        enable = true;
        grammars = [treesitterDiffGrammer.default];
      };
    })
  ]);
}
