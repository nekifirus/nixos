{ config, pkgs, lib, ... }:

{
  imports = [
    ./email.nix
    ./emacs.nix
    ./gpg.nix
    ./tmux.nix
    ./git.nix
    ./rofi.nix
    ./alacritty.nix
    ./fish.nix
    ./xresources.nix
  ];

  services.syncthing = {
    enable = true;
    tray.enable = false;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    nix-direnv.enableFlakes = true;
  };
  
  programs.ssh.enable = false;

  xsession = {
    initExtra = ''
    xset -dpms
    xset s off
    '';
  };

  programs.home-manager.enable = true;
}
