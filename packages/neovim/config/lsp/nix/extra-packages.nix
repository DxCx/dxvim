{ pkgs, ... }:

with pkgs;
[
  # Helper to update git deps
  update-nix-fetchgit

  # Language Servers
  nixd

  # Formatters
  nixfmt-rfc-style

  # Diagnostics
  deadnix
  statix

  # Documentation
  manix
]
