_: {
  ## TODO: Must setup and test before go:
  # Leader key stuff.
  # TODO: Browse languges, and map what i am using.
  # check which plugin highlights TODO and such, i want that here too.

  ### CODING
  # LSP configuration
  lsp = {
    formatOnSave = true;
    lspkind.enable = false;
    lightbulb.enable = true;
    lspsaga.enable = false;
    trouble.enable = true;
    otter-nvim.enable = false;
    lsplines.enable = false;
    nvim-docs-view.enable = false;
  };

  # Language configuration
  languages = {
    enableLSP = true;
    enableFormat = true;
    enableTreesitter = true;
    enableExtraDiagnostics = true;

    # TODO: Isolate language configuration
    nix.enable = true;
    clang.enable = true;
  };

  # Treesitter context configuration
  mini.ai.enable = true;
  treesitter = {
    context.enable = true;
  };

  # Comments configuration
  comments = {
    comment-nvim.enable = true;
  };

  ### MAPPINGS
  # Key bindings configuration
  binds = {
    whichKey.enable = true;
    cheatsheet.enable = true;
  };

  ### GENERAL
  # Git configuration
  git = {
    enable = true;
    gitsigns.enable = true;
    gitsigns.codeActions.enable = false; # throws an annoying debug message
  };

  # Notification configuration
  notify = {
    nvim-notify.enable = true;
  };

  # Autocomplete configuration
  autocomplete = {
    enableSharedCmpSources = true;
    blink-cmp = {
      enable = true;
      mappings = {
        confirm = "<C-y>";
        close = "<Esc>";
        next = "<C-n>";
        previous = "<C-p>";
      };
      setupOpts = {
        signature.enabled = true;
      };
    };
  };

  # Utility configuration
  utility = {
    ccc.enable = false;
    vim-wakatime.enable = false;
    icon-picker.enable = false;
    surround.enable = false;
    diffview-nvim.enable = true;
    images = {
      image-nvim.enable = false;
    };
  };

  # Session configuration
  session = {
    nvim-session-manager.enable = false;
  };
}
