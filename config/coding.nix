{pkgs, ...}: {
  # LSP configuration
  lsp = {
    formatOnSave = true;
    lspkind.enable = true;
    # Lightbulb icon when cursor on word that has code action attached to it.
    lightbulb.enable = false;
    lspsaga = {
      enable = true;
      setupOpts = {
        lightbulb.enable = false;
      };
    };
    trouble.enable = true;
    otter-nvim.enable = false;
    lsplines.enable = false;
    nvim-docs-view.enable = false;
  };

  # Language configuration
  # TODO: integrate lsp-inlayhints
  # TODO: Lsp key bindings?
  # TODO: Integrate reafactoring? Check out if needed with nvim 0.11 oob functionality
  languages = {
    enableLSP = true;
    enableFormat = true;
    enableTreesitter = true;
    enableExtraDiagnostics = true;

    ### Language specific configurations
    nix = {
      enable = true;
    };

    markdown = {
      enable = true;
    };

    bash = {
      enable = true;
    };

    # Asm Configuration
    assembly = {
      enable = true;
    };

    # C/C++ configuration
    clang = {
      enable = true;
      # Downgrade for compatability with NS
      lsp.package = pkgs.clang-tools_17;
    };

    # Lua configuration
    lua = {
      enable = true;
    };

    # Python configuration
    python = {
      enable = true;
    };

    # Rust configuration
    rust = {
      enable = true;
    };

    # TODO: Docker

    # TODO: Diagram / PlantUML

    # TODO: CMake

    # TODO: Don't have diagnostics in place, trouble? and what is the annoying bulb?????

    # Web configuration
    ts = {
      enable = true;
    };

    html = {
      enable = true;
    };

    css = {
      enable = true;
    };

    sql = {
      enable = true;
    };

    # TODO: GraphQL

    # TODO: Javascript?
  };

  # Treesitter context configuration
  mini.ai.enable = true;
  treesitter = {
    indent.enable = true;
    highlight.enable = true;
    context.enable = true;
  };

  # Comments configuration
  comments = {
    comment-nvim.enable = true;
  };
}
