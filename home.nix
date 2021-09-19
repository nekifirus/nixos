{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  xsession = {
    initExtra = ''
    xset -dpms
    xset s off
    '';
  };

  programs.home-manager.enable = true;
}
