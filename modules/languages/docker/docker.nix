{lib, ...}: let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) bool;
in {
  options.vim.languages.docker = {
    enable = mkEnableOption "Docker/Dockerfile language support";

    treesitter = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Enable Dockerfile treesitter grammar";
      };
    };

    lsp = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Enable docker-language-server LSP";
      };
    };
  };
}
