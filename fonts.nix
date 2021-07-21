{ config, pkgs, lib, ... }:

{
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      inter
      ibm-plex
      iosevka
      source-code-pro
      emacs-all-the-icons-fonts
      pkgs.ubuntu_font_family
    ];
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Ubuntu" "Iosevka"  ];
        sansSerif = [ "Ubuntu" "Iosevka" ];
        monospace = [ "Iosevka Light" "IBM Plex Mono 13" ];
      };
    };
  };
}
