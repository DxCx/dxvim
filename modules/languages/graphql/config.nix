{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.nvim.types) mkGrammarOption;

  cfg = config.vim.languages.graphql;
  graphqlGrammar = mkGrammarOption pkgs "graphql";
in {
  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter = {
        enable = true;
        grammars = [graphqlGrammar.default];
      };
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.servers.graphql = {
        enable = true;
        package = pkgs.graphql-language-service-cli;
        cmd = ["${pkgs.graphql-language-service-cli}/bin/graphql-lsp" "server" "-m" "stream"];
        filetypes = ["graphql" "typescriptreact" "javascriptreact" "typescript" "javascript"];
        root_markers = [".graphqlrc" ".graphqlrc.json" ".graphqlrc.yaml" ".graphqlrc.yml" "graphql.config.js" "graphql.config.ts" ".git"];
      };
    })
  ]);
}
