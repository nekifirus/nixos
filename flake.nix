{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs?rev=08ef0f28e3a41424b92ba1d203de64257a9fca6a";

  
  outputs = { self, nixpkgs }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [  ./configuration.nix ];
    };
  };
}
