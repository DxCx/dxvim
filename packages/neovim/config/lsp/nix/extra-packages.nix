{ pkgs, ... }:

with pkgs; [
  # Helper to update git deps
  update-nix-fetchgit

  # Language Servers
  nixd

  # Formatters
  nixfmt

  # Diagnostics
  deadnix
  statix

  # Documentation
  manix
]
