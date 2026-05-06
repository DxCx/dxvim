# DxVim

A Neovim distribution built with [nvf](https://github.com/notashelf/nvf), packaged as a Nix flake.

## Development commands

```bash
nix build              # Build the neovim package (default output)
nix run .              # Run the built nvim
nix flake check        # Run all checks (eval, build, plugin smoke test, format, lint, deadnix)
nix run nixpkgs#alejandra -- .   # Format Nix files
nix run nixpkgs#statix -- check . # Lint Nix files
```

CI mirrors these checks; PRs must pass `nix flake check`.

## Architecture

- `flake.nix` — flake inputs and outputs. Wires nvf, plugin sources, and the dxnixinfra-provided check/devshell scaffolding via `dxnixinfra.lib.mkFlakeOutputs`.
- `config/` — user-facing nvf configuration, one file per concern (`coding.nix`, `navigation.nix`, `theme.nix`, etc.). `default.nix` merges them all into `config.vim`.
- `modules/` — custom nvf modules that extend the option tree (e.g. `vim.assistant.*`, `vim.languages.*`). Each module is a directory with `options.nix` + `config.nix` + `default.nix`. The top-level `default.nix` auto-imports every subdirectory.
- Plugin sources not in nixpkgs are pulled as flake inputs (`sidekick-nvim`, `hop-nvim-patched`) and threaded through `extraSpecialArgs`.

## Inputs and updates

`dxnixinfra` is the single source of truth for `nixpkgs` and `flake-utils`:

```nix
dxnixinfra.url = "github:DxCx/dxnixinfra";
nixpkgs.follows = "dxnixinfra/nixpkgs";
flake-utils.follows = "dxnixinfra/flake-utils";
```

To bump nixpkgs, bump dxnixinfra — do not pin nixpkgs directly here. Renovate updates flake inputs and GitHub Actions; dependency PRs auto-merge once CI passes.

## Conventions

- Formatter: alejandra (2-space indent). Lint: statix. Both run in CI and block on findings.
- New features go in their own `config/<feature>.nix` or, if they need configurable options, in a `modules/<category>/<plugin>/` triplet.
- Use `mkKeymap` from `lib.nvim.binds` and always set a `desc`.
- Keep plugin setup options explicit — don't rely on upstream defaults.
