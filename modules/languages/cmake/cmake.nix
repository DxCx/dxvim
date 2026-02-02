{lib, ...}: let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) bool;
in {
  options.vim.languages.cmake = {
    enable = mkEnableOption "CMake language support";

    treesitter = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Enable CMake treesitter grammar";
      };
    };

    lsp = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Enable cmake-language-server LSP";
      };
    };
  };
}
