# DxVim

DxCx vim configuration

## git configuration

```gitconfig
[core]
    editor = "nix run ~/dxvim -- "
[merge]
    tool = vimdiff
[mergetool "vimdiff"]
    cmd = "nix run ~/dxvim -- -d \"$LOCAL\" \"$MERGED\" \"$BASE\" \"$REMOTE\" -c \"wincmd w\" -c \"wincmd J\""
```
