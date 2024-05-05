{
  pkgs,
  python311Packages,
  nodePackages,
  ...
}:
with pkgs;
[
  # Markdown
  marksman
  python311Packages.mdformat
  nodePackages.markdownlint-cli

  # JSON (jsonls)
  nodePackages.vscode-langservers-extracted
  nodePackages.jsonlint

  # YAML (yamlls)
  nodePackages.yaml-language-server
  yamllint

  # TOML
  taplo

  # General, used by many (JSON, YAML)
  nodePackages.prettier
]
