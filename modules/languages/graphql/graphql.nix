{lib, ...}: let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) bool;
in {
  options.vim.languages.graphql = {
    enable = mkEnableOption "GraphQL language support";

    treesitter = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Enable GraphQL treesitter grammar";
      };
    };

    lsp = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Enable graphql-language-service LSP";
      };
    };
  };
}
