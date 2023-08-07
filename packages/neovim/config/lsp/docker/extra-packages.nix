{ pkgs
, nodePackages
, ...
}:

with pkgs; [
  nodePackages.dockerfile-language-server-nodejs

  hadolint
]
