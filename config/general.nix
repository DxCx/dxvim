{lib, ...}: let
  inherit (lib.generators) mkLuaInline;

  snacksConfig = {
    utility = {
      snacks-nvim = {
        enable = true;
        setupOpts = {
          toggle = {enabled = true;};
          quickfile = {enabled = true;};
          bigfile = {
            enabled = true;
            notify = true;
            size = 100 * 1024; # 100 KB
          };
          bufdelete = {enabled = true;};
        };
      };
    };
  };
in
  {
    # basic
    bell = "visual";
    options = {
      termguicolors = true;
      updatetime = 10; # Update UI every 10ms
      timeoutlen = 250;
      expandtab = true;
      encoding = "utf-8";
      autoindent = true;
      smartindent = false; # Treesitter taking over.
      cursorline = true;
      tabstop = 4;
      shiftwidth = 2;
      wrap = false;
      linebreak = true;
      list = false;
      ignorecase = true;
      smartcase = false;
      backspace = "indent,eol,start";
      hlsearch = true;
      wrapscan = true;
      incsearch = true;
      inccommand = "nosplit";
      history = 1000;
      undolevels = 1000;
      wildignore = "*.swp,*.bak,*.pyc,*.class";
      hidden = true;
      backup = false;
      swapfile = false;
      spelllang = "en_us";

      #Stop the sign column from flashing in/out with gitsigns.
      signcolumn = "yes";

      #We're professionals here.
      mouse = "";
    };

    # Git configuration
    git = {
      enable = true;
      gitsigns = {
        enable = true;
        mappings = {
          toggleBlame = "<leader>tb";
          toggleDeleted = null;
        };
        setupOpts = {
          signcolumn = true;
          numhl = false;
          linehl = false;
          word_diff = false;
          current_line_blame = true;

          # Workaround autoformatting on save which makes Gitsigns process twice without delay.
          update_debounce = 10;
        };
        codeActions.enable = false; # throws an annoying debug message
      };
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
          completion = {
            list = {
              selection = {
                auto_insert = false;
              };
            };

            menu = {
              draw = {
                treesitter = ["lsp"];
                columns = mkLuaInline ''
                  {
                      {"label", "label_description", gap = 1},
                      {"kind_icon", "kind"}
                  }
                '';
              };
            };
          };
        };
      };
    };

    # Utility configuration
    utility = {
      ccc.enable = true;
      icon-picker.enable = true;
      diffview-nvim.enable = true;
      images = {
        image-nvim.enable = false;
      };
    };
  }
  // snacksConfig
