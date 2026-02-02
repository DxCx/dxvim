{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.nvim.types) mkGrammarOption;

  cfg = config.vim.languages.cmake;
  cmakeGrammar = mkGrammarOption pkgs "cmake";
in {
  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter = {
        enable = true;
        grammars = [cmakeGrammar.default];
      };
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.servers.cmake = {
        enable = true;
        package = pkgs.cmake-language-server;
        cmd = ["${pkgs.cmake-language-server}/bin/cmake-language-server"];
        filetypes = ["cmake"];
        root_markers = ["CMakeLists.txt" "CMakePresets.json" ".git"];
      };
    })
  ]);
}
