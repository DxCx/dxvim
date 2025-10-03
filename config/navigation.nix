{
  lib,
  pkgs,
  hop-nvim-patched,
  ...
}: let
  inherit (lib.nvim.binds) mkKeymap;
  inherit (lib.generators) mkLuaInline;
  inherit (lib.nvim.dag) entryAnywhere;

  # Telescope configuration (Between buffers)
  # TODO: Replace telescope?
  telescopeCustomCmd = "TelescopeFindFiles";
  telescopeCustomFindFilesBackend = ''
    local api = require("telescope.builtin")
    local is_in_git = function()
        local paths = vim.fs.find('.git', {
            limit = 1,
            upward = true,
            type = 'directory',
        })

        return #paths > 0
    end

    local telescope_find_files_ext = function()
        if (is_in_git()) then
            api.git_files()
        else
            api.find_files()
        end
    end

    vim.api.nvim_create_user_command('${telescopeCustomCmd}', telescope_find_files_ext, { range = false })
  '';

  telescopeConfig = {
    pluginRC.telescope-custom-find-files = entryAnywhere telescopeCustomFindFilesBackend;
    keymaps = [
      (mkKeymap "n" "<C-p><C-p>" "<cmd>${telescopeCustomCmd}<CR>" {desc = "Find (Git) file [Telescope]";})
    ];
    telescope = {
      enable = true;
      mappings = {
        findProjects = null;
        gitStatus = "<C-p>g";
        liveGrep = "<C-p>s";
        buffers = "<C-p>b";
        helpTags = "<C-p>h";
        findFiles = null;
        open = null;
        resume = null;

        gitCommits = null;
        gitBufferCommits = null;
        gitBranches = null;
        gitStash = null;

        lspDocumentSymbols = null;
        lspWorkspaceSymbols = "<C-p>o";
        lspReferences = null;
        lspImplementations = null;
        lspDefinitions = null;
        lspTypeDefinitions = "<C-p>t";
        diagnostics = "<C-p>d";

        treesitter = null;
      };
    };
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
    telescopeConfig
  ]
