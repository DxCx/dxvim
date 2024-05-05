{
  pkgs,
  nodePackages,
  python311Packages,
  ...
}:
with pkgs;
[
  nodePackages.pyright

  mypy
  ruff

  # 2 formatting options, black is more aggresive
  black
  python311Packages.autopep8
  python311Packages.flake8
]
