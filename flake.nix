{
  description = "Nekifirus system";

  inputs = {
    inputs.nixpkgs.url = "github:NixOS/nixpkgs?rev=08ef0f28e3a41424b92ba1d203de64257a9fca6a";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follow = "nixpkgs";
    
  };

  
  outputs = { self, nixpkgs }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [  ./configuration.nix ];
    };
  };
}
