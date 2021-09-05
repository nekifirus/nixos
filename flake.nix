{
  description = "Nekifirus system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=08ef0f28e3a41424b92ba1d203de64257a9fca6a";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  
  outputs = { self, nixpkgs, home-manager, ... }: 
    let 
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        
        config = { allowUnfree = true; };
      };

      lib = nixpkgs.lib;
      
    in {
      homeManagerConfigurations = {
        nekifirus = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs;

          username = "nekifirus";
          homeDirectory = "/home/nekifirus";
          configuration = [
            ./home.nix
          ];
        };
      };
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
        
          modules = [
            ./configuration.nix
          ];
        };
      };
    };
}
