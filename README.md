# DxVim

nix based DxCx vim configuration

## Install nix

Instructions can be found [here](https://nixos.org/download)

TL:DR is `sh <(curl -L https://nixos.org/nix/install) --daemon`

# Overview

- Packaged as a Nix Flake
- Made using nvf https://github.com/NotAShelf/nvf
  - https://notashelf.github.io/nvf/options.html
- Inspired base from https://github.com/mewoocat/nvim-nvf

# Installation

### NixOS Flake

Add this repo to the flake inputs,

```
inputs = {
    ...
    DxVim.url = "github:DxCx/dxvim";
    ...
};
```

Then add `inputs.DxVim.packages.x86_64-linux.default` to your packages

## git configuration

```gitconfig
[core]
    editor = "nix run ~/dxvim -- "
[merge]
    tool = vimdiff
[mergetool "vimdiff"]
    cmd = "nix run ~/dxvim -- -d \"$LOCAL\" \"$MERGED\" \"$BASE\" \"$REMOTE\" -c \"wincmd w\" -c \"wincmd J\""
```
