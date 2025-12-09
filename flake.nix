{
  description = "Nekifirus system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    slackpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };


  outputs = inputs @ { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      nixos-thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          home-manager.nixosModules.home-manager
          ./nixos-thinkpad-host.nix
          ./system/nix_config.nix
          ./system/home.nix

          ./system/zram.nix
          ./system/packages.nix
          #./system/openvpn.nix
          #./system/redshift.nix
          ./system/sound.nix
          ./system/virtualisation.nix
          #./system/yggdrasil.nix
          ./system/fonts.nix
          ./system/locale.nix
          ./system/users.nix

          ./user/alacritty.nix
          ./user/xserver.nix
          ./user/gnome.nix
          ./user/email.nix
          ./user/emacs.nix
          ./user/gpg.nix
          ./user/tmux.nix
          ./user/git.nix
          ./user/rofi.nix
          ./user/gtk.nix
          ./user/bash.nix
          ./user/xresources.nix
          #./user/syncthing.nix
          ./user/direnv.nix
          ./user/ssh.nix
          ./user/network_manager.nix
          ./user/browser.nix
        ];
      };
      nixos-asus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          home-manager.nixosModules.home-manager
          ./nixos-asus-host.nix
          ./system/nix_config.nix

          # ./system/openvpn.nix
          ./system/packages.nix
          ./system/sound.nix
          ./system/virtualisation.nix
          #./system/yggdrasil.nix
          ./system/fonts.nix
          ./system/locale.nix
          ./system/users.nix

          ./user/alacritty.nix
          ./user/xserver.nix
          ./user/gnome.nix
          # ./user/email.nix
          ./user/emacs.nix
          ./user/gpg.nix
          ./user/tmux.nix
          ./user/git.nix
          ./user/rofi.nix
          ./user/gtk.nix
          ./user/bash.nix
          ./user/xresources.nix
          #./user/syncthing.nix
          ./user/direnv.nix
          ./user/ssh.nix
          ./user/network_manager.nix
          ./user/browser.nix

          ./user/email.nix
        ];
      };
    };
  };
}
