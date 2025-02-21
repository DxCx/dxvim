{lib, ...}: let
  inherit (lib.nvim.binds) mkKeymap;
  hopKeyBindings = [
    (mkKeymap "n" "<leader>p" "<cmd>HopPattern<CR>" {desc = "Hop To Pattern";})
    (mkKeymap "n" "<leader>a" "<cmd>HopAnywhere<CR>" {desc = "Hop Anywhere";})
    (mkKeymap "n" "b" "<cmd>HopWordBC<CR>" {desc = "Hop To Previous Word";})
    (mkKeymap "n" "w" "<cmd>HopWordAC<CR>" {desc = "Hop To Next Word";})
  ];
in {
  # Telescope configuration (Between buffers)
  # TODO: Replace telescope?
  telescope = {
    enable = true;
    mappings = {
      findProjects = null;
      findFiles = "<C-p><C-p>";
      liveGrep = "<C-p>s";
      buffers = "<C-p>b";
      helpTags = "<C-p>h";
      open = null;
      resume = null;

      gitCommits = null;
      gitBufferCommits = null;
      gitBranches = null;
      gitStatus = null;
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

  # Inside buffer
  utility = {
    motion = {
      hop = {
        enable = true;
        mappings.hop = null;
      };
      leap.enable = false;
      precognition.enable = false;
    };
  };

  keymaps = hopKeyBindings;
}
