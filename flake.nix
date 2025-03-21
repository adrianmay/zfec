{
  description = "An efficient, portable erasure coding tool";

  inputs = {
    # Nix Inputs
    nixpkgs.follows = "hs-flake-utils/nixpkgs";
    flake-utils.url = github:numtide/flake-utils;
    hs-flake-utils.url = "git+https://gitlab.com/tahoe-lafs/hs-flake-utils.git?ref=main";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    hs-flake-utils,
  }: let
    ulib = flake-utils.lib;
  in
    ulib.eachSystem ["x86_64-linux"] (system: let
      hslib = hs-flake-utils.lib {
        pkgs = nixpkgs.legacyPackages.${system};
        src = ./.;
        compilerVersion = "ghc8107";
        packageName = "fec";
      };
    in {
      checks = hslib.checks {};
      devShells = hslib.devShells {};
      packages = hslib.packages {};
      apps = {
        hlint = hslib.apps.hlint {argv = ["haskell/"];};
        cabal-test = hslib.apps.cabal-test {
          extraRuntimeInputs = pkgs: [
            # Some build-time dependencies of old-time, a transitive
            # dependency of ours...
            pkgs.gnused
            pkgs.gawk
          ];
          testTargetName = "test:tests";
        };
      };
    });
}
