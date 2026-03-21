{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      inter
      ibm-plex
      iosevka
      source-code-pro
      emacs-all-the-icons-fonts
      ubuntu-classic
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
