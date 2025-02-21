{
  config,
  lib,
  pkgs,
  ...
}:
let
  args = { inherit config lib pkgs; };
in
{
  config.vim = import ./general.nix args;
}
