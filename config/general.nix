{lib, ...}: let
  inherit (lib.generators) mkLuaInline;
in {
  # basic
  bell = "visual";
  options = {
    termguicolors = true;
    updatetime = 10; # Update UI every 10ms
    timeoutlen = 250;
    expandtab = false;
    encoding = "utf-8";
    ## TODO: How to fix indent?
    autoindent = true;
    smartindent = false; # Treesitter taking over.
    cursorline = true;
    tabstop = 4;
    shiftwidth = 4;
    wrap = false;
    wrapscan = false;
    linebreak = true;
    list = false;
    ignorecase = true;
    smartcase = true;
    backspace = "indent,eol,start";
    hlsearch = true;
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

  ## TODO: Must setup and test before go:
  # Leader key stuff.
  # TODO: Browse languges, and map what i am using.
  # check which plugin highlights TODO and such, i want that here too.

  # TODO: HexMode plugin
  # TODO: UndoTree plugin

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
