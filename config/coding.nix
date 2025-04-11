{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.nvim.binds) mkKeymap;

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
        # TODO: Toggle Inlay hints?
      };
    };
  };

  # C/C++ configuration
  clangConfig = {
    keymaps = [
      (mkKeymap "n" "gh" "<cmd>ClangdSwitchSourceHeader<CR>" {desc = "Switch Source/Header [clangd]";})
    ];
    languages = {
      clang = {
        enable = true;
        # Downgrade for compatability with NS
        lsp.package = pkgs.clang-tools_17;
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
  ]
