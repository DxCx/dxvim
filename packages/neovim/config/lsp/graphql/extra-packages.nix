# TODO: Re-enable later?
#{
#  fetchFromGitHub,
#  buildNpmPackage,
#  ...
#}:
#let
#  graphql-language-service-cli = buildNpmPackage rec {
#    name = "graphql-language-service-cli";
#    version = "3.5.0";
#    src = fetchFromGitHub {
#      owner = "graphql";
#      repo = "graphiql";
#      rev = "${name}@${version}";
#      # replace with lib.fakeHash to extract newer hash.
#      hash = "sha256-NJTggaMNMjOP5oN+gHxFTwEdNipPNzTFfA6f975HDgM=";
#    };
#    sourceRoot = "${src.name}/packages/graphql-language-service-cli/";
#  };
#in
#[ graphql-language-service-cli ]
_: [ ]
