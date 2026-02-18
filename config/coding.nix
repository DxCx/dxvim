{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.nvim.binds) mkKeymap;
  inherit (lib.modules) mkForce;

  refactoringNvim = {
    lazy.plugins = {
      "refactoring.nvim" = {
        package = pkgs.vimPlugins.refactoring-nvim;
        lazy = false;
        setupModule = "refactoring";
        setupOpts = {};
      };
    };
    keymaps = [
      (mkKeymap "x" "<leader>cre" "<cmd>Refactor extract<CR>" {desc = "Extract [refactoring]";})
      (mkKeymap "x" "<leader>crf" "<cmd>Refactor extract_to_file<CR>" {desc = "Extract to file [refactoring]";})
      (mkKeymap "x" "<leader>crv" "<cmd>Refactor extract_var<CR>" {desc = "Extract variable [refactoring]";})
      (mkKeymap ["n" "x"] "<leader>cri" "<cmd>Refactor inline_var<CR>" {desc = "Inline variable [refactoring]";})
      (mkKeymap "n" "<leader>crI" "<cmd>Refactor inline_func<CR>" {desc = "Inline function [refactoring]";})
      (mkKeymap "n" "<leader>crb" "<cmd>Refactor extract_block<CR>" {desc = "Extract block [refactoring]";})
      (mkKeymap "n" "<leader>crbf" "<cmd>Refactor extract_block_to_file<CR>" {desc = "Extract block to file [refactoring]";})
    ];
  };

  lspMappings = {
    keymaps = [
      (mkKeymap "n" "<leader>ti"
        "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>"
        {desc = "Toggle Inlay Hints [LSP]";})
    ];
    lsp = {
      mappings = {
        goToDefinition = "gd";
        goToDeclaration = "gD";
        nextDiagnostic = "[d";
        previousDiagnostic = "]d";
        signatureHelp = "<C-k>";
        renameSymbol = "<leader>crr";
        codeAction = "<leader>ca";
        format = "=";
        toggleFormatOnSave = "<leader>tf";
      };
    };
  };

  # C/C++ configuration
  clangConfig = let
    # Select clang-tools version here - update this line to change versions
    clangTools = pkgs.llvmPackages_19.clang-tools;
  in {
    keymaps = [
      (mkKeymap "n" "gh" "<cmd>ClangdSwitchSourceHeader<CR>" {desc = "Switch Source/Header [clangd]";})
    ];
    languages = {
      clang = {
        enable = true;
      };
    };
    # Add clang-tools package to make clangd available
    extraPackages = [clangTools];
    # Configure custom clangd version via new LSP servers API
    # Use mkForce to override the default clangd from nvf's clang module
    lsp = {
      servers = {
        clangd = {
          cmd = mkForce ["${clangTools}/bin/clangd"];
        };
      };
    };
  };
in
  lib.mkMerge [
    clangConfig
    lspMappings
    refactoringNvim

    {
      # LSP configuration
      lsp = {
        enable = true;
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
        nvim-docs-view.enable = false;
        inlayHints.enable = true;
      };

      diagnostics = {
        enable = true;
        config = {
          virtual_lines = true;
        };
      };

      # Language configuration
      languages = {
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

        # Docker configuration
        docker.enable = true;

        # CMake configuration
        cmake.enable = true;

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

        # GraphQL configuration
        graphql.enable = true;

        # Data format languages
        json.enable = true;
        yaml.enable = true;
        toml.enable = true;
      };

      # Treesitter context configuration
      mini.ai.enable = true;
      treesitter = {
        enable = true;
        indent.enable = true;
        highlight.enable = true;
        context.enable = true;
        textobjects.enable = true;
      };

      # Comments configuration
      comments = {
        comment-nvim.enable = true;
      };
    }
  ]
