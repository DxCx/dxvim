{pkgs, ...}: {
  extraPackages = with pkgs; [
    direnv
  ];
  lazy.plugins = {
    "direnv.vim" = {
      package = pkgs.vimPlugins.direnv-vim;
      lazy = false;
    };
  };
}
