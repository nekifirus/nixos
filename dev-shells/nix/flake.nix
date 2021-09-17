{
  description = "Nix development shell";

  outputs = { self, nixpkgs }: 
    let pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      packages.x86_64-linux.rnix-lsp = pkgs.rnix-lsp;
      devShell.x86_64-linux =  pkgs.mkShell {
        buildInputs = [ self.packages.x86_64-linux.rnix-lsp ];
        shellHook = "echo PATH";
      };
  };
}
