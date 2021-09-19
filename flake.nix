{
  description = "Nekifirus system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };


  outputs = inputs @ { self, nixpkgs, home-manager, emacs-overlay, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          inputs.home-manager.nixosModules.home-manager
          ./nix_config.nix
          ./configuration.nix
          ./alacritty.nix
          ./hardware-configuration.nix
          ./xserver.nix
          ./packages.nix
          ./redshift.nix
          ./fonts.nix
          ./yggdrasil.nix
          ./locale.nix
          ./email.nix
          ./emacs.nix
          ./gpg.nix
          ./tmux.nix
          ./git.nix
          ./rofi.nix
          ./bash.nix
          ./xresources.nix
          ./syncthing.nix
          ./direnv.nix
          ./ssh.nix
          ./virtualisation.nix
          ./network_manager.nix
          ./openvpn.nix
          ./sound.nix
          ./users.nix
          ./browser.nix
        ];
      };
    };
  };
}
