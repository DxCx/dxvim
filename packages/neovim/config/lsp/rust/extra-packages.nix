{ pkgs
, nodePackages
, ...
}:

with pkgs; [
  rust-analyzer
  rustfmt
]
