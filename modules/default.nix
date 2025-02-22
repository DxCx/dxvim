{lib, ...}: let
  # Get all files in the current directory
  files = lib.filterAttrs (n: v: v == "directory" && n != "default.nix") (builtins.readDir ./.);

  # Convert the attribute set of files to a list of paths
  modules = lib.mapAttrsToList (name: _: import ./${name}) files;
in {
  imports = modules;
}
