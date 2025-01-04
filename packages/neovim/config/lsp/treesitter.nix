{
  vimPlugins,
  tree-sitter,
  fetchFromGitHub,
  ...
}:
let
  origianl-nvim-treesitter = vimPlugins.nvim-treesitter;

  updated-treesitter = origianl-nvim-treesitter.withPlugins (
    _:
    origianl-nvim-treesitter.allGrammars
    ++ [
      (tree-sitter.buildGrammar {
        language = "plantuml";
        version = "unstable-2021-12-09";
        src = fetchFromGitHub {
          owner = "lyndsysimon";
          repo = "tree-sitter-plantuml";
          rev = "fe25cf8592ea12ad6de00379a444d376ba32c7b5";
          sha256 = "0cd78pp8blg4s56g9g6ia416965smdlafyyn3biks887nqji00mw";
        };
      })
    ]
  );

  res = updated-treesitter;
in
res
