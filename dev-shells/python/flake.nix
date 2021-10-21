{
  description = "Python 3.9 shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: (
    utils.lib.eachSystem [ "x86_64-linux" ] (
      system: rec {

        packages = {
          pythonEnv = nixpkgs.legacyPackages.${system}.python39.withPackages (
            ps: with ps; [
              pip
              python-lsp-server
              isort
            ]
          );
        };

        defaultPackage = packages.pythonEnv; # If you want to juist build the environment
        devShell = packages.pythonEnv.env; # We need .env in order to use `nix develop`
      }
    )
  );
}
