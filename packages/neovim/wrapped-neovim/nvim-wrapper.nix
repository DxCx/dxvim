{
  lib,
  neovim-unwrapped,
  wrapNeovimUnstable,
  neovimUtils,
  lua51Packages,
  ...
}:

let
  mkNvimWrapper =
    config-object:
    let
      extra-make-wrapper-args = ''--prefix PATH : "${lib.makeBinPath config-object.extra-packages}"'';
      extra-make-wrapper-lua-args = ''--prefix LUA_PATH ";" "${
        lib.concatMapStringsSep ";" lua51Packages.getLuaPath config-object.extra-lua-packages
      }"'';
      extra-make-wrapper-lua-c-args = ''--prefix LUA_CPATH ";" "${
        lib.concatMapStringsSep ";" lua51Packages.getLuaCPath config-object.extra-lua-packages
      }"'';

      default-plugin = {
        type = "viml";
        plugin = null;
        config = "";
        optional = false;
        runtime = { };
      };

      # Plugins can be either a package or a Neovim plugin attribute set.
      # We need to normalize them such that they are all plugin attribute sets.
      normalized-plugins = builtins.map (
        plugin: default-plugin // (if (plugin ? plugin) then plugin else { inherit plugin; })
      ) config-object.all-plugins;

      suppress-not-viml-config =
        plugin: if plugin.type != "viml" then plugin // { config = ""; } else plugin;

      custom-rc = ''
        lua <<EOF
          -- Allow imports from common locations for some packages.
          -- This is required for things like lua_ls to work.
          local runtime_path = vim.split(package.path, ";")
          table.insert(runtime_path, "lua/?.lua")
          table.insert(runtime_path, "lua/?/init.lua")
        EOF

        " Custom VIML Config.
        ${config-object.vim-config}

        " Custom Lua Config.
        ${config-object.lua-config}
      '';

      neovim-config = neovimUtils.makeNeovimConfig {
        viAlias = true;
        vimAlias = true;
        extraPython3Packages = config-object.extra-python3-packages;

        withPython3 = true;
        withRuby = true;
        withNodeJs = true;

        plugins = builtins.map suppress-not-viml-config normalized-plugins;
        customRC = custom-rc;
      };

      # Original nvim on nixpkgs treat all deps as "Suffix" and not "Prefix" meaning
      # it will take system's binary, before taking Nix's, which breaks the whole concept..
      # This will fix it so we will "prefix" them and they will get priority
      fixed-wrapper-args = lib.lists.forEach neovim-config.wrapperArgs (
        arg: if arg == "--suffix" then "--prefix" else arg
      );

      neovim-config-with-wrapper-args = neovim-config // {
        wrapRc = true;
        wrapperArgs =
          (lib.escapeShellArgs fixed-wrapper-args)
          + " "
          + extra-make-wrapper-args
          + " "
          + extra-make-wrapper-lua-args
          + " "
          + extra-make-wrapper-lua-c-args;
      };

      wrapped-neovim = wrapNeovimUnstable neovim-unwrapped neovim-config-with-wrapper-args;
    in
    wrapped-neovim.overrideAttrs (_: {
      meta = with lib; {
        platforms = with platforms; linux ++ darwin;
      };
    });
in
{
  inherit mkNvimWrapper;
}
