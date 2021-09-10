{
  description = "Nekifirus system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=08ef0f28e3a41424b92ba1d203de64257a9fca6a";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "https://github.com/nix-community/emacs-overlay/archive/abc392cf4bd06dfa7b08fece4982445f845fbbe4.tar.gz";
  };


  outputs = inputs @ { self, nixpkgs, home-manager, emacs-overlay, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      lib = nixpkgs.lib;

    in
      {
        # homeManagerConfigurations = {
        #   nekifirus = home-manager.lib.homeManagerConfiguration {
        #     inherit system pkgs;

        #     username = "nekifirus";
        #     homeDirectory = "/home/nekifirus";
        #     configuration = {
        #       imports = [
        #         ./home.nix
        #       ];
        #     };
        #   };
        # };
        nixosConfigurations = {
          nixos = lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit inputs;
            };
            modules = [
              inputs.home-manager.nixosModules.home-manager
              (
                { pkgs, ... }: {
                  nix.extraOptions = "experimental-features = nix-command flakes";
                  nix.package = pkgs.nixUnstable;
                  nix.registry.nixpkgs.flake = inputs.nixpkgs;
                  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
                  home-manager.useGlobalPkgs = true;
                }
              )
              
              ./emacs-overlay.nix
              ./configuration.nix
            ];
          };
        };
      };
}
