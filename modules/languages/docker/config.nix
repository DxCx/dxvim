{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.nvim.types) mkGrammarOption;

  cfg = config.vim.languages.docker;
  dockerGrammar = mkGrammarOption pkgs "dockerfile";
in {
  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter = {
        enable = true;
        grammars = [dockerGrammar.default];
      };
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.servers.docker-langserver = {
        enable = true;
        package = pkgs.docker-language-server;
        cmd = ["${pkgs.docker-language-server}/bin/docker-language-server" "--stdio"];
        filetypes = ["dockerfile"];
        root_markers = ["Dockerfile" ".git"];
      };
    })
  ]);
}
