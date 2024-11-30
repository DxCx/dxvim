{ pkgs, ... }:

with pkgs;
[
  nodejs-slim_latest # CoPilot depends on nodejs
  lynx # for extra documentation
]
