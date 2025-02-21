{
  config,
  lib,
  pkgs,
  ...
}: let
  args = {inherit config lib pkgs;};
in {
  config.vim = lib.mkMerge [
    (import ./assistant.nix args)
    (import ./coding.nix args)
    (import ./dashboard.nix args)
    (import ./direnv.nix args)
    (import ./general.nix args)
    (import ./hextools.nix args)
    (import ./keys.nix args)
    (import ./navigation.nix args)
    (import ./stay-centered.nix args)
    (import ./theme.nix args)
    (import ./ui.nix args)
    (import ./undo-tree.nix args)
  ];
}
