# DxVim

nix based DxCx vim configuration

## Install nix

Instructions can be found [here](https://nixos.org/download)

TL:DR is `sh <(curl -L https://nixos.org/nix/install) --daemon`

## git configuration

```gitconfig
[core]
    editor = "nix run ~/dxvim -- "
[merge]
    tool = vimdiff
[mergetool "vimdiff"]
    cmd = "nix run ~/dxvim -- -d \"$LOCAL\" \"$MERGED\" \"$BASE\" \"$REMOTE\" -c \"wincmd w\" -c \"wincmd J\""
```
