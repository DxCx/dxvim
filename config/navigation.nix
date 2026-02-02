{
  lib,
  pkgs,
  hop-nvim-patched,
  ...
}: let
  inherit (lib.nvim.binds) mkKeymap;
  inherit (lib.generators) mkLuaInline;
  inherit (lib.nvim.dag) entryAnywhere;

  # Snacks picker configuration (replaces Telescope)
  snacksPickerBackend = ''
    local snacks_find_files = function()
      local paths = vim.fs.find('.git', {
        limit = 1,
        upward = true,
        type = 'directory',
      })
      if #paths > 0 then
        Snacks.picker.git_files()
      else
        Snacks.picker.files()
      end
    end
    vim.api.nvim_create_user_command('SnacksPickerFiles', snacks_find_files, { range = false })
  '';

  snacksPickerConfig = {
    pluginRC.snacks-picker-backend = entryAnywhere snacksPickerBackend;
    keymaps = [
      (mkKeymap "n" "<C-p>" "<cmd>SnacksPickerFiles<CR>" {desc = "Find (Git) files [Snacks]";})
      (mkKeymap "n" "<C-p>s" "<cmd>lua Snacks.picker.grep()<CR>" {desc = "Live grep [Snacks]";})
      (mkKeymap "n" "<C-p>b" "<cmd>lua Snacks.picker.buffers()<CR>" {desc = "Buffers [Snacks]";})
      (mkKeymap "n" "<C-p>r" "<cmd>lua Snacks.picker.recent()<CR>" {desc = "Recent files [Snacks]";})
      (mkKeymap "n" "<C-p>o" "<cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>" {desc = "Workspace symbols [Snacks]";})
      (mkKeymap "n" "<C-p>d" "<cmd>lua Snacks.picker.diagnostics()<CR>" {desc = "Diagnostics [Snacks]";})
      (mkKeymap "n" "<C-p>h" "<cmd>lua Snacks.picker.help()<CR>" {desc = "Help [Snacks]";})
      (mkKeymap "n" "<C-p>g" "<cmd>lua Snacks.picker.git_status()<CR>" {desc = "Git status [Snacks]";})
    ];
    telescope.enable = false; # Replaced by Snacks picker
  };

  # hop config, Inside buffer
  # See https://github.com/phaazon/hop.nvim/issues/345
  # Using patched version from flake input
  hop-nvim-pkg = pkgs.vimUtils.buildVimPlugin {
    pname = "hop.nvim";
    version = "unstable-2022-11-08";
    src = hop-nvim-patched;
  };

  hopKeyBindings = [
    (mkKeymap "n" "<leader>p" "<cmd>HopPattern<CR>" {desc = "Hop To Pattern";})
    (mkKeymap "n" "<leader>a" "<cmd>HopAnywhere<CR>" {desc = "Hop Anywhere";})
    # Intentionally override default w/b word motions with hop equivalents.
    # This provides faster navigation by allowing direct jumps to any visible word.
    (mkKeymap "n" "b" "<cmd>HopWordBC<CR>" {desc = "Hop To Previous Word";})
    (mkKeymap "n" "w" "<cmd>HopWordAC<CR>" {desc = "Hop To Next Word";})
  ];

  hopConfig = {
    utility = {
      motion = {
        leap.enable = false;
        precognition.enable = false;
        hop = {
          enable = false;
          mappings.hop = null;
        };
      };
    };
    lazy.plugins = {
      "hop.nvim" = {
        package = hop-nvim-pkg;
        lazy = false;
        setupModule = "hop";
        setupOpts = {};
      };
    };
    keymaps = hopKeyBindings;
  };
in
  lib.mkMerge [
    hopConfig
    snacksPickerConfig
  ]
