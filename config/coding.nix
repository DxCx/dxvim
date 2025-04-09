{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.nvim.binds) mkKeymap;

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
