{
  description = "Flake to manage clojure workspace";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            jdk11
            clojure
            leiningen
            clj-kondo
            # clojure-lsp <-- https://github.com/NixOS/nixpkgs/issues/122557 
          ];
          shellHook = ''
            export JAVA_HOME=${pkgs.jdk11}
            PATH="${pkgs.jdk11}/bin:$PATH"
          '';
        };
      });
}
