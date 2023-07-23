{ lib
, substituteAll
, symlinkJoin
, nodePackages
, prisma-engines
, makeWrapper
, runCommand
, ...
}:

with lib;
let
  # Usage:
  # mkLuaConfig ./some-file.lua {
  #   MY_ARG = "hello-world";
  # }
  mkLuaConfig = file: args:
    let module =
      substituteAll
        (args // {
          src = file;
        });
    in
    "luafile ${module}";

  # Usage:
  # mkLuaConfigs [
  #   ./some-file.lua
  #   { file = ./some-other.lua; options = { MY_ARG = "hello-world"; }; }
  # ]
  mkLuaConfigs = files:
    lib.concatMapStringsSep "\n"
      (file:
        if builtins.isAttrs file then
          mkLuaConfig file.file file.options
        else
          mkLuaConfig file { }
      )
      files;
in
mkLuaConfigs [
  ./bufferline.lua
  ./scope.lua
  ./cmp.lua
  ./dashboard.lua
  ./fzf.lua
  ./git.lua
  ./gitsigns.lua
  ./hop.lua
  ./icon-picker.lua
  ./keys.lua
  {
    file = ./lspconfig.lua;
    options = {
      typescript = "${nodePackages.typescript}/lib/node_modules/typescript";
      typescriptLanguageServer = "${nodePackages.typescript-language-server}/bin/typescript-language-server";
      # eslintLanguageServer = "${wrappedESLintLanguageServer}/bin/vscode-eslint-language-server";
      htmlLanguageServer = "${nodePackages.vscode-langservers-extracted}/bin/vscode-html-language-server";
      cssLanguageServer = "${nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server";
      jsonLanguageServer = "${nodePackages.vscode-langservers-extracted}/bin/vscode-json-language-server";
      dockerLanguageServer = "${nodePackages.dockerfile-language-server-nodejs}/bin/docker-langserver";
    };
  }
  ./lualine.lua
  ./neoscroll.lua
  ./nord.lua
  ./telescope.lua
  ./tmux-navigator.lua
  ./todo-comments.lua
  ./toggleterm.lua
  ./tree-sitter.lua
  ./tree.lua
  ./trouble.lua
  ./twilight.lua
  ./vim.lua
  ./bookmarks.lua
  ./indent.lua
  ./context.lua
  ./which-key.lua
  ./wrap-toggle.lua
]

