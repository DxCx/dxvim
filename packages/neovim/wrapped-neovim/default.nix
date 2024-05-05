{ callPackage, ... }:
let
  nvim-wrapper = callPackage ./nvim-wrapper.nix { };
  config-lib = callPackage ./config-funcs.nix { };

  # Usage:
  # mkWrappedNeovim {
  #  layouts = [
  #    # Layout directories to include. TODO: Refer to my other doc which explains this.
  #  ];
  #  description = "description for the nix flake";
  #  mainProgram = "exported target for nix flake";
  # }
  mkWrappedNeovim =
    user-input:
    let
      config-object = config-lib.concatVimConfigurations user-input.layouts;
      nvim-wrapper-object = nvim-wrapper.mkNvimWrapper config-object;
      final-object = nvim-wrapper-object.overrideAttrs (oldAttrs: {
        meta = {
          platforms = oldAttrs.meta.platforms;
          description = user-input.description;
          mainProgram = user-input.mainProgram;
        };
      });
    in
    final-object;
in
{
  inherit mkWrappedNeovim;
}
