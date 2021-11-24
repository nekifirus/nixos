{
  description = "Node development shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: 
    utils.lib.eachSystem [ "x86_64-linux" ] (
      system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs-16_x
          ];
          shellHook = ''
             echo HELLO from nodeshell
          '';
        };
      });
}
#     let pkgs = nixpkgs.legacyPackages.x86_64-linux;
#     in {
#       packages.x86_64-linux.nodejs = pkgs.nodejs-16_x;
#       packages.x86_64-linux.git = pkgs.git;
#       packages.x86_64-linux.glibcLocales = pkgs.glibcLocales;
#       devShell.x86_64-linux =  pkgs.mkShell {
#         buildInputs = [
#           self.packages.x86_64-linux.nodejs
#           self.packages.x86_64-linux.git
#           self.packages.x86_64-linux.glibcLocales
#         ];
#         shellHook = ''
#                   export LANG="en_US.UTF-8"
#                   export LC_ALL="en_US.UTF-8"
#                   '';              
#       };
#   };
# }

