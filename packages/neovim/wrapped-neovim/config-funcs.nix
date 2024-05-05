{
  lib,
  substituteAll,
  callPackage,
  ...
}:
with lib;
let
  # Usage:
  # mkVimConfig ./some-file.vim {
  #   MY_ARG = "hello-world";
  # }
  mkVimConfig =
    file: args:
    let
      module = substituteAll (args // { src = file; });
    in
    "source ${module}";

  # Usage:
  # mkVimConfigs [
  #   ./some-file.vim
  #   { file = ./some-other.vim; options = { MY_ARG = "hello-world"; }; }
  # ]
  mkVimConfigs =
    files:
    lib.concatMapStringsSep "\n" (
      file: if builtins.isAttrs file then mkVimConfig file.file file.options else mkVimConfig file { }
    ) files;

  # Usage:
  # mkLuaConfig ./some-file.lua {
  #   MY_ARG = "hello-world";
  # }
  mkLuaConfig =
    file: args:
    let
      module = substituteAll (args // { src = file; });
    in
    "luafile ${module}";

  # Usage:
  # mkLuaConfigs [
  #   ./some-file.lua
  #   { file = ./some-other.lua; options = { MY_ARG = "hello-world"; }; }
  # ]
  mkLuaConfigs =
    files:
    lib.concatMapStringsSep "\n" (
      file: if builtins.isAttrs file then mkLuaConfig file.file file.options else mkLuaConfig file { }
    ) files;

  # Usage:
  # callPackages [
  #   ./some-file.nix
  #   { file = ./some-other.nix; options = { MY_ARG = "hello-world"; }; }
  # ]
  callPackages =
    packages:
    lib.lists.concatMap (
      layoutInput:
      if builtins.isAttrs layoutInput then
        callPackage layoutInput.file layoutInput.options
      else
        callPackage layoutInput { }
    ) packages;

  # helper to get directory out of both syntaxes ./layout or { dir = ./layout, options = { } }
  evaluateLayoutInputDirectory =
    layoutInput: if builtins.isAttrs layoutInput then layoutInput.dir else layoutInput;

  # Helper to concat filename when directory can be either bare or extanded syntax
  concatFilename = directory: filename: "${evaluateLayoutInputDirectory directory}/${filename}";

  # Helper to check if file exists
  inputExists = directory: filename: builtins.pathExists (concatFilename directory filename);

  # Filters assets that are not relevant because the user didn't define them.
  filterExistingAssets =
    layouts: filename: builtins.filter (layout: inputExists layout filename) layouts;

  # Fallbacks to empty options if options was provided but not specifically for this part.
  getOptionsKeyOrDefault =
    optionsAttrsSet: optionsKey:
    if builtins.hasAttr optionsKey optionsAttrsSet then
      builtins.getAttr optionsKey optionsAttrsSet
    else
      { };

  # Fallbacks to empty options if extanded syntax not provided
  getOptionOrDefault =
    layoutInput: optionsKey:
    if builtins.isAttrs layoutInput then getOptionsKeyOrDefault layoutInput.options optionsKey else { };

  # Helper to convert user input into the right format
  buildInputList =
    layouts: filename: optionsKey:
    let
      existingInputs = filterExistingAssets layouts filename;
      existingMappedInputs = lib.lists.forEach existingInputs (
        layout:
        let
          file = concatFilename layout filename;
          options = getOptionOrDefault layout optionsKey;
        in
        {
          inherit file;
          inherit options;
        }
      );
    in
    existingMappedInputs;

  # Usage:
  # Layout directory can contain the following files:
  #  - plugins.nix -- Which vim plugins to download and install as part of this layer
  #  - extra-packages.nix -- Which extra nix packages to install to support those plugins
  #  - extra-lua-packages.nix -- Which lua packages to install to support those plugins
  #  - extra-python3-packages.nix -- Which lua packages to install to support those plugins
  #  - init.vim -- vim script to include to support this layer.
  #  - init.lua -- lua script to include to support this layer.
  #
  # All the files are optional, and if not found they will just ignored and not merged togather.
  # The extanded syntax allows control over options per step, with the following attribute keys:
  #  - plugins -- for plugins.nix
  #  - extra-packages -- for extra-packages.nix
  #  - extra-lua-packages -- for extra-lua-packages.nix
  #  - extra-python3-packages -- for extra-python3-packages.nix
  #  - vim -- for init.vim
  #  - lua -- for init.lua
  #
  # concatVimConfigurations [
  #   ./layout_directory
  #   { file = ./layout_directory; options = { plugins = { MY_ARG = "hello-world"; }; extra-packages = { MY_ARG2 = "hello-worldz"; } }; }
  # ]
  concatVimConfigurations = (
    layouts:
    let
      vim-plugins = buildInputList layouts "plugins.nix" "plugins";
      vim-extra-packages = buildInputList layouts "extra-packages.nix" "extra-packages";
      vim-extra-lua-packages = buildInputList layouts "extra-lua-packages.nix" "extra-lua-packages";
      vim-extra-python3-packages =
        buildInputList layouts "extra-python3-packages.nix"
          "extra-python3-packages";
      vim-config-files = buildInputList layouts "init.vim" "vim";
      vim-lua-config-files = buildInputList layouts "init.lua" "lua";

      all-plugins = callPackages vim-plugins;
      extra-packages = callPackages vim-extra-packages;
      extra-lua-packages = callPackages vim-extra-lua-packages;
      extra-python3-packages = python-packages: callPackages vim-extra-python3-packages;

      vim-config = mkVimConfigs vim-config-files;
      lua-config = mkLuaConfigs vim-lua-config-files;
    in
    {
      inherit all-plugins;
      inherit extra-packages;
      inherit extra-lua-packages;
      inherit extra-python3-packages;

      inherit vim-config;
      inherit lua-config;
    }
  );
in
{
  inherit concatVimConfigurations;
}
