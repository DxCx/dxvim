{ vimPlugins, vimUtils, fetchFromGitHub, ... }:
let
  dbsession-nvim = vimUtils.buildVimPlugin {
    pname = "dbsession.nvim";
    version = "unstable-2023-06-28";
    src = fetchFromGitHub {
      owner = "nvimdev";
      repo = "dbsession.nvim";
      rev = "cdf680b9ed91c735418706b1125df91e5ba39251";
      sha256 = "0brlbwci5v49day1bmzsmz73n64367lgmv01frp3758i1dhz75ah";
    };
  };
in with vimPlugins; [
  # Icons (For Dashboard)
  nvim-web-devicons

  # Dashboard
  dashboard-nvim
  dbsession-nvim
]
